#!/usr/bin/env python3
"""
PR Submitter — Creates a git branch, commits changes, and prepares a PR
for the openEuler container images repository.

Usage:
    python submit_pr.py --app-name nginx --tag 1.27.2-oe2403sp3 \\
        --repo-path /tmp/openeuler-docker-images \\
        [--remote origin] [--base-branch master] [--dry-run]
"""

import argparse
import os
import subprocess
import sys


def run_git(repo_path: str, *args, check: bool = True) -> subprocess.CompletedProcess:
    """Run a git command in the repo directory."""
    return subprocess.run(
        ['git', '-C', repo_path] + list(args),
        capture_output=True, text=True, check=check,
    )


def submit_pr(
    repo_path: str,
    app_name: str,
    tag: str,
    commit_message: str = None,
    remote: str = 'origin',
    base_branch: str = 'master',
    dry_run: bool = False,
) -> dict:
    """
    Create a branch, commit changes, and push for PR.

    Returns a dict with branch info and PR creation URL.
    """
    branch_name = f'add-{app_name}-{tag}'

    if not commit_message:
        commit_message = (
            f'Add {app_name} container image ({tag})\n\n'
            f'- Dockerfile for {app_name} on openEuler\n'
            f'- README.md with usage instructions\n'
            f'- meta.yml with tag: {tag}\n'
            f'- Update image-list.yml\n'
        )

    steps = []

    try:
        # Check if repo is clean (or at least check current state)
        status = run_git(repo_path, 'status', '--porcelain')
        if not status.stdout.strip():
            return {
                'success': False,
                'error': 'No changes to commit. Working tree is clean.',
                'branch': branch_name,
            }

        steps.append('Found uncommitted changes')

        # Create branch
        if dry_run:
            steps.append(f'[DRY RUN] Would create branch: {branch_name}')
        else:
            # Check if branch already exists
            result = run_git(repo_path, 'branch', '--list', branch_name)
            if result.stdout.strip():
                steps.append(f'Branch {branch_name} already exists, checking out')
                run_git(repo_path, 'checkout', branch_name)
            else:
                run_git(repo_path, 'checkout', '-b', branch_name)
            steps.append(f'Created/checked out branch: {branch_name}')

        # Stage changes
        if dry_run:
            steps.append('[DRY RUN] Would stage and commit changes')
        else:
            # Only stage files in the repo (not .claude/ itself)
            run_git(repo_path, 'add', '--all', '--', ':.')
            # Unstage .agents if it got staged (we don't want to commit the tool itself)
            # But if it's the first commit of .agents, that's fine

            # Commit
            run_git(repo_path, 'commit', '-m', commit_message)
            steps.append('Changes committed')

            # Show commit
            log = run_git(repo_path, 'log', '-1', '--oneline')
            steps.append(f'Commit: {log.stdout.strip()}')

        # Push
        if dry_run:
            steps.append(f'[DRY RUN] Would push to {remote}/{branch_name}')
        else:
            push_result = run_git(
                repo_path, 'push', '-u', remote, branch_name,
                check=False,
            )
            if push_result.returncode != 0:
                steps.append(f'Push failed: {push_result.stderr[-300:]}')
                return {
                    'success': False,
                    'error': 'Push failed. You may need to fork the repo first.',
                    'branch': branch_name,
                    'steps': steps,
                    'push_stderr': push_result.stderr[-500:],
                }
            steps.append(f'Pushed to {remote}/{branch_name}')

        # Generate PR URL
        # Detect remote type
        remote_url = run_git(repo_path, 'remote', 'get-url', remote).stdout.strip()

        if 'gitcode.com' in remote_url:
            pr_url = remote_url.rstrip('.git') + '/-/merge_requests/new'
            if 'merge_request' in pr_url:
                pr_url += f'?merge_request[source_branch]={branch_name}'
        elif 'gitee.com' in remote_url:
            pr_url = remote_url.rstrip('.git') + '/pulls/new'
        elif 'github.com' in remote_url:
            pr_url = remote_url.rstrip('.git') + f'/pull/new/{branch_name}'
        else:
            pr_url = f'{remote_url}/-/merge_requests/new'  # GitLab format

        return {
            'success': True,
            'branch': branch_name,
            'tag': tag,
            'remote': remote,
            'base_branch': base_branch,
            'pr_url': pr_url,
            'commit_message': commit_message,
            'steps': steps,
        }

    except subprocess.CalledProcessError as e:
        return {
            'success': False,
            'error': f'Git command failed: {e.stderr}' if e.stderr else str(e),
            'branch': branch_name,
            'steps': steps,
        }


def main():
    parser = argparse.ArgumentParser(
        description='Create PR for openEuler container image')
    parser.add_argument('--app-name', required=True, help='Software name')
    parser.add_argument('--tag', required=True, help='Image tag')
    parser.add_argument('--repo-path', required=True,
                       help='Path to openeuler-docker-images repository')
    parser.add_argument('--remote', default='origin', help='Git remote name')
    parser.add_argument('--base-branch', default='master', help='Base branch for PR')
    parser.add_argument('--message', '-m', help='Custom commit message')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be done without doing it')

    args = parser.parse_args()

    result = submit_pr(
        repo_path=args.repo_path,
        app_name=args.app_name,
        tag=args.tag,
        commit_message=args.message,
        remote=args.remote,
        base_branch=args.base_branch,
        dry_run=args.dry_run,
    )

    if result['success']:
        print(f'\nBranch:   {result["branch"]}')
        print(f'PR URL:   {result["pr_url"]}')
        for step in result.get('steps', []):
            print(f'  - {step}')
    else:
        print(f'\nERROR: {result.get("error", "Unknown error")}', file=sys.stderr)
        for step in result.get('steps', []):
            print(f'  - {step}')
        sys.exit(1)


if __name__ == '__main__':
    main()
