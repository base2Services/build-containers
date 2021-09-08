#!/usr/local/bin/python

import os

from github_backup.github_backup import (
    backup_account,
    backup_repositories,
    check_git_lfs_install,
    filter_repositories,
    get_authenticated_user,
    log_info,
    mkdir_p,
    parse_args,
    retrieve_repositories,
)


def main():
    args = parse_args()

    output_directory = os.path.realpath(args.output_directory)
    if not os.path.isdir(output_directory):
        log_info('Create output directory {0}'.format(output_directory))
        mkdir_p(output_directory)

    if args.lfs_clone:
        check_git_lfs_install()

    if not args.as_app:
        log_info('Backing up user {0} to {1}'.format(args.user, output_directory))
        authenticated_user = get_authenticated_user(args)
    else:
        authenticated_user = {'login': None}

    repositories = retrieve_repositories(args, authenticated_user)
    repositories = filter_repositories(args, repositories)
    backup_repositories(args, output_directory, repositories)
    backup_account(args, output_directory)


if __name__ == '__main__':
    main()
