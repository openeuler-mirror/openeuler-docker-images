#!/usr/bin/env python3
"""
Image List Updater — Adds a new application image entry to the category's
image-list.yml file if it doesn't already exist.

Usage:
    python update_image_list.py --category Others --app-name nginx \\
        --repo-path /tmp/openeuler-docker-images
    python update_image_list.py --category Others --app-name nginx \\
        --app-path "OPEA/AudioQnA/nginx" --repo-path /tmp/openeuler-docker-images
"""

import argparse
import os
import sys

import yaml


def update_image_list(
    repo_path: str,
    category: str,
    app_name: str,
    app_path: str = None,
) -> dict:
    """
    Add an entry to the category's image-list.yml.

    Args:
        repo_path: Root of the openeuler-docker-images repository
        category: Category directory name (e.g., 'Others', 'Database')
        app_name: Application/image name
        app_path: Relative path from category root (defaults to app_name)

    Returns:
        dict with 'updated', 'was_present', 'entry', 'file_path'
    """
    # Normalize category name
    category_map = {
        'bigdata': 'Bigdata', 'ai': 'AI', 'storage': 'Storage',
        'database': 'Database', 'cloud': 'Cloud', 'hpc': 'HPC',
        'distroless': 'Distroless', 'others': 'Others',
    }
    # Also handle already-correct case
    for k, v in list(category_map.items()):
        category_map[v] = v
    category_dir = category_map.get(category, category)

    image_list_path = os.path.join(repo_path, category_dir, 'image-list.yml')

    if not os.path.exists(image_list_path):
        return {
            'updated': False,
            'was_present': False,
            'error': f'image-list.yml not found at {image_list_path}',
            'file_path': image_list_path,
        }

    # Read existing
    with open(image_list_path) as f:
        data = yaml.safe_load(f) or {}

    if 'images' not in data:
        data['images'] = {}

    entry_path = app_path if app_path else app_name
    was_present = app_name in data['images']

    if was_present:
        print(f'Entry "{app_name}" already exists in {image_list_path}')
        return {
            'updated': False,
            'was_present': True,
            'entry': {app_name: data['images'][app_name]},
            'file_path': image_list_path,
        }

    # Add new entry (maintain alphabetical order if possible)
    data['images'][app_name] = entry_path

    # Sort entries alphabetically
    sorted_images = dict(sorted(data['images'].items()))
    data['images'] = sorted_images

    # Write back preserving format
    with open(image_list_path, 'w') as f:
        f.write('images:\n')
        for name, path in data['images'].items():
            f.write(f'  {name}: {path}\n')

    print(f'Added "{app_name}: {entry_path}" to {image_list_path}')

    return {
        'updated': True,
        'was_present': False,
        'entry': {app_name: entry_path},
        'file_path': image_list_path,
    }


def main():
    parser = argparse.ArgumentParser(
        description='Update image-list.yml with a new image entry')
    parser.add_argument('--category', required=True,
                       help='Category: Bigdata, AI, Storage, Database, Cloud, HPC, Others')
    parser.add_argument('--app-name', required=True, help='Application name')
    parser.add_argument('--app-path', help='Relative path from category root (defaults to app-name)')
    parser.add_argument('--repo-path', required=True,
                       help='Path to openeuler-docker-images repository')

    args = parser.parse_args()

    result = update_image_list(
        repo_path=args.repo_path,
        category=args.category,
        app_name=args.app_name,
        app_path=args.app_path,
    )

    if result.get('error'):
        print(f'ERROR: {result["error"]}', file=sys.stderr)
        sys.exit(1)

    if result['was_present']:
        print('No changes needed.')
    elif result['updated']:
        print('image-list.yml updated successfully.')
    else:
        print('No action taken.')


if __name__ == '__main__':
    main()
