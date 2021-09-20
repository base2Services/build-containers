import os, sys, subprocess, re, boto3, tarfile, logging, datetime, concurrent.futures, git


logging.basicConfig(level=logging.INFO)
BACKUP_ACCOUNT = os.environ['ACCOUNT']


def download_backup():
    s3 = boto3.client('s3')

    get_last_modified = lambda obj: int(obj['LastModified'].strftime('%s'))

    backup_times = []

    for account in BACKUP_ACCOUNTS:
        objs = s3.list_objects_v2(Bucket=os.environ['BUCKET'], Prefix=f'github/{account}/')['Contents']
        last_added = [obj['Key'] for obj in sorted(objs, key=get_last_modified)]
        last_added = last_added[len(last_added)-1]
        logging.info(f'Last added file in {account}: {last_added}')

        time = s3.get_object_tagging(
            Bucket='base2-backups-608551091241-ap-southeast-2',
            Key=last_added
        )
        time = int(time['TagSet'][0]['Value'])/1000
        time = datetime.datetime.fromtimestamp(time)
        backup_times.append(time)
        logging.info(f'Time of {account} backup: {time}')

        s3.download_file('base2-backups-608551091241-ap-southeast-2', last_added, f'{account}.tar.gz')
        # extract from archive
        my_tar = tarfile.open(f'{account}.tar.gz')
        my_tar.extractall(path=f'./{account}')
        my_tar.close()

    return backup_times


def compair_local_remote(local, remote):
    logging.info(f'Local:  {local}\nRemote: {remote}')
    if remote == local:
        logging.info("match")
        return True
    else:
        logging.info('no match')
        return False


def get_commits(account, repo_name, location, backup_times=None):
    path = f'{account}/repositories/{repo_name}/repository/'
    repo = git.Repo(path)
    if location == 'remote':
        for remote in repo.remotes:
            remote.fetch()
    # get a list of all  branches and format names
    branches = [refs.name for refs in repo.remote().refs]
    logging.info(f'{location} branches (unformated): {branches}')
    logging.info(f'{location} branches (fromated): {branches}')

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
    logging.info(f'###########{repo}###########\n')

    local_commits = get_commits(account, repo, 'local')
    logging.info(f'Latest local commits: {local_commits}')

    remote_commits = get_commits(account, repo, 'remote', backup_times)
    logging.info(f'Latest remote commits: {remote_commits}')

    for branch, commit in local_commits.items():
        valid = compair_local_remote(local_commits[branch], remote_commits[branch])
        if valid:
            valid_branches.append(branch)
        else:
            invalid_branches.append({'branch': branch, 'local_commit': commit, 'remote_commit': remote_commits[branch]})
    logging.info(f'valid branches: {valid_branches}')
    logging.info(f'invalid branches: {invalid_branches}')
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

    repo_names = os.listdir(f'{account}/repositories')
    logging.info(f'repos: {repo_names}')

    # Loop though all repo's within the account concurrently
    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = [executor.submit(check_repo, repo_name, account, backup_times, valid_repos, invalid_repos, could_not_check) for repo_name in repo_names]

        for future in futures:
            future.result()

    logging.warning('################ Valid Repos #####################')
    logging.warning(valid_repos)
    logging.warning('################ Invalid Repos ###################')
    logging.warning(invalid_repos)
    logging.warning('################ Could Not Check #################')
    logging.warning(could_not_check)



if __name__ == '__main__':
    main()
