#!/usr/bin/env python

import os
import boto3
import tarfile
import logging
import json
import concurrent.futures
from time import time
from git import Repo

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

BACKUP_ACCOUNT = os.environ['GITHUB_BACKUP_VALIDATION_ORG']
BACKUP_BUCKET = os.environ['GITHUB_BACKUP_BUCKET']
BACKUP_TIMESTAMP = os.environ.get('GITHUB_BACKUP_TIMESTAMP', None)


def download_backup():
    s3 = boto3.client('s3')

    if BACKUP_TIMESTAMP is not None:
        s3_object = "github/{BACKUP_ACCOUNT}/{BACKUP_ACCOUNT}-{GITHUB_BACKUP_TIMESTAMP}.tar.gz"
    else:
        # get the last backup taken
        get_last_modified = lambda obj: int(obj['LastModified'].strftime('%s'))
        objs = s3.list_objects_v2(Bucket=BACKUP_BUCKET, Prefix=f'github/{BACKUP_ACCOUNT}/')['Contents']
        s3_object = [obj['Key'] for obj in sorted(objs, key=get_last_modified, reverse=True)][0]
        logger.info(f'last backup found for {BACKUP_ACCOUNT}: s3://{BACKUP_BUCKET}/{s3_object}')

    logger.info(f"downloading backup tar from s3 ...")
    s3.download_file(BACKUP_BUCKET, s3_object, f'{BACKUP_ACCOUNT}.tar.gz')
    
    tags = s3.get_object_tagging(Bucket=BACKUP_BUCKET, Key=s3_object)
    backup_time = next(int(tag['Value']) for tag in tags['TagSet'] if tag['Key'] == 'upload_time')
    logger.info(f'time of github org {BACKUP_ACCOUNT} backup: {backup_time}')
    
    # extract from archive
    my_tar = tarfile.open(f'{BACKUP_ACCOUNT}.tar.gz')
    my_tar.extractall(path=f'./{BACKUP_ACCOUNT}')
    my_tar.close()

    return backup_time


def get_latest_commit(account, repo_name, location, backup_time=None):
    path = f'{account}/repositories/{repo_name}/repository/'
    repo = Repo(path)

    if location == 'remote':
        for remote in repo.remotes:
            remote.fetch()

    # just validate origin/HEAD
    if backup_time is not None:
        # get the latest commit from the specified date comparing int timestamps
        last_commit = next((commit for commit in repo.iter_commits() if commit.committed_date <= backup_time), None)
    else:
        last_commit = repo.head.commit
    
    return last_commit.hexsha


def check_repo(repo, account, backup_time, valid_repos, invalid_repos, could_not_check):
    logger.info(f'validating repository {BACKUP_ACCOUNT}/{repo}')

    try:
        local_commit = get_latest_commit(account, repo, 'local')
        remote_commit = get_latest_commit(account, repo, 'remote', backup_time)
    except Exception as e:
        could_not_check.append({'repo': repo, 'error': str(e)})
        logger.error(f"failed to check repository {repo}", exc_info=True)
        return

    logger.info(f'{repo}: (local) {local_commit} (remote) {remote_commit}')
    
    if local_commit is None or remote_commit is None or local_commit != remote_commit:
        invalid_repos.append({'repo': repo, 'local_commit': local_commit, 'remote_commit': remote_commit}) 
    else:
        valid_repos.append({'repo': repo})
        


def main():
    valid_repos = []
    invalid_repos = []
    could_not_check =[]

    # Download the archive file from s3
    validation_time = time()
    backup_time = download_backup()

    repo_names = os.listdir(f'{BACKUP_ACCOUNT}/repositories')

    # Loop though all repo's within the account concurrently
    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = [executor.submit(check_repo, repo_name, BACKUP_ACCOUNT, backup_time, valid_repos, invalid_repos, could_not_check) for repo_name in repo_names]

        for future in futures:
            future.result()

    logger.info(f'{len(repo_names)} repos were checked')
    logger.info(f'{len(valid_repos)} repos were valid')
    
    if len(invalid_repos) > 0:
        logger.error(f'{len(invalid_repos)} repos were invalid')

    if len(could_not_check) > 0: 
        logger.error(f'{len(could_not_check)} repos could not be checked')

    repos_checked = len(valid_repos) + len(invalid_repos) + len(could_not_check)

    if repos_checked != len(repo_names):
        logger.error(f'repositories checked {repos_checked} does not match the repositories count in the backup tar {len(repo_names)}')

    repo_results = {
        "backup_time": backup_time,
        "validation_time": validation_time,
        "repositories_checked": repos_checked,
        "repositories_in_backup": len(repo_names),
        "account": BACKUP_ACCOUNT,
        "results": {
            "valid_repos": {
                "count": len(valid_repos),
                "details": valid_repos
            }, 
            "invalid_repos": {
                "count": len(invalid_repos), 
                "details": invalid_repos
            }, 
            "could_not_check": {
                "count": len(could_not_check), 
                "details": could_not_check
            }
        }
    }

    with open('repos.json', 'w') as f:
        f.write(json.dumps(repo_results))


if __name__ == '__main__':
    main()
