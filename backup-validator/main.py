import os, sys, subprocess, re, boto3, tarfile, logging, datetime, json, concurrent.futures, git


logging.basicConfig(level=logging.DEBUG)
BACKUP_ACCOUNT = os.environ['GITHUB_BACKUP_VALIDATION_ORG']


def download_backup():
    s3 = boto3.client('s3')

    get_last_modified = lambda obj: int(obj['LastModified'].strftime('%s'))

    backup_times = []

    objs = s3.list_objects_v2(Bucket=os.environ['GITHUB_BACKUP_BUCKET'], Prefix=f'github/{BACKUP_ACCOUNT}/')['Contents']
    last_added = [obj['Key'] for obj in sorted(objs, key=get_last_modified)]
    last_added = last_added[len(last_added)-1]
    logging.debug(f'Last added file in {BACKUP_ACCOUNT}: {last_added}')

    time = s3.get_object_tagging(
        Bucket=os.environ['GITHUB_BACKUP_BUCKET'],
        Key=last_added
    )
    time = int(time['TagSet'][0]['Value'])/1000
    time = datetime.datetime.fromtimestamp(time)
    backup_times.append(time)
    logging.debug(f'Time of {BACKUP_ACCOUNT} backup: {time}')

    s3.download_file(os.environ['GITHUB_BACKUP_BUCKET'], last_added, f'{BACKUP_ACCOUNT}.tar.gz')
    # extract from archive
    my_tar = tarfile.open(f'{BACKUP_ACCOUNT}.tar.gz')
    my_tar.extractall(path=f'./{BACKUP_ACCOUNT}')
    my_tar.close()

    return backup_times


def compair_local_remote(local, remote):
    logging.debug(f'Local:  {local}\nRemote: {remote}')
    if remote == local:
        logging.debug("match")
        return True
    else:
        logging.debug('no match')
        return False


def get_commits(account, repo_name, location, backup_times=None):
    path = f'{account}/repositories/{repo_name}/repository/'
    repo = git.Repo(path)
    if location == 'remote':
        for remote in repo.remotes:
            remote.fetch()
    # get a list of all  branches and format names
    branches = [refs.name for refs in repo.remote().refs]
    logging.debug(f'{location} branches (unformated): {branches}')
    logging.debug(f'{location} branches (fromated): {branches}')

    # Create a dictionary of the most recent  commit and branch name
    commits = {}
    for branch in branches:
        try:
            # checkout the current branch
            repo.git.stash('save')
            repo.git.checkout(branch)
            commit = repo.head.commit.hexsha
            commits.update({branch: commit})
        except:
            commits.update({branch: None})
    return commits


def check_repo(repo, account, backup_times, valid_repos, invalid_repos, could_not_check):
    valid_branches = []
    invalid_branches = []
    logging.debug(f'###########{repo}###########\n')

    local_commits = get_commits(account, repo, 'local')
    logging.debug(f'Latest local commits: {local_commits}')

    remote_commits = get_commits(account, repo, 'remote', backup_times)
    logging.debug(f'Latest remote commits: {remote_commits}')

    for branch, commit in local_commits.items():
        valid = compair_local_remote(local_commits[branch], remote_commits[branch])
        if valid:
            valid_branches.append(branch)
        else:
            invalid_branches.append({'branch': branch, 'local_commit': commit, 'remote_commit': remote_commits[branch]})
    logging.debug(f'valid branches: {valid_branches}')
    logging.debug(f'invalid branches: {invalid_branches}')
    if len(valid_branches) > 0:
        valid_repos.update({repo: valid_branches})
    if len(invalid_branches) > 0:
        invalid_repos.update({repo: invalid_branches})


def main():
    valid_repos = {}
    invalid_repos = {}
    could_not_check =[]

    # Download the archive file from s3
    backup_times = download_backup()

    repo_names = os.listdir(f'{BACKUP_ACCOUNT}/repositories')
    logging.debug(f'repos: {repo_names}')

    # Loop though all repo's within the account concurrently
    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = [executor.submit(check_repo, repo_name, BACKUP_ACCOUNT, backup_times, valid_repos, invalid_repos, could_not_check) for repo_name in repo_names]

        for future in futures:
            future.result()

    logging.info('################ Valid Repos #####################')
    logging.info(valid_repos)
    logging.info('################ Invalid Repos ###################')
    logging.info(invalid_repos)
    logging.info('################ Could Not Check #################')
    logging.info(could_not_check)

    repo_results = {"valid_repos": [len(valid_repos), valid_repos], "invalid_repos": [len(invalid_repos), invalid_repos], "could_not_check": [len(could_not_check), could_not_check]}

    with open('repos.json', 'w') as f:
        f.write(json.dumps(repo_results))


if __name__ == '__main__':
    main()
