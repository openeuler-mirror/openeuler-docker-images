#!/usr/bin/env python3
"""
File Generator — Creates the complete directory structure and all required files
for a new openEuler container image contribution.

Creates:
    1. Directory tree: <category>/<app>/<version>/<oe-version>/
    2. Dockerfile at the correct path
    3. README.md for the app
    4. meta.yml for the app
    5. Optional: doc/image-info.yml, doc/picture/

Usage:
    python generate_files.py --app-name nginx --version 1.27.2 \\
        --category Others --oe-version 24.03-lts-sp3 \\
        --dockerfile /path/to/Dockerfile \\
        --readme /path/to/README.md \\
        --meta /path/to/meta.yml \\
        --repo-path /tmp/openeuler-docker-images
"""

import argparse
import os
import sys
import yaml


def create_directory_structure(
    app_name: str,
    version: str,
    oe_version: str,
    category: str,
    repo_path: str,
    dockerfile_content: str,
    readme_content: str,
    meta_content: str,
    doc_dir: bool = False,
    image_info: dict = None,
    logo_path: str = None,
) -> dict:
    """Create all directories and files for an openEuler container image."""

    created_files = []
    errors = []

    # Normalize category name
    category_map = {
        'bigdata': 'Bigdata',
        'ai': 'AI',
        'storage': 'Storage',
        'database': 'Database',
        'cloud': 'Cloud',
        'hpc': 'HPC',
        'distroless': 'Distroless',
        'others': 'Others',
        'Bigdata': 'Bigdata',
        'AI': 'AI',
        'Storage': 'Storage',
        'Database': 'Database',
        'Cloud': 'Cloud',
        'HPC': 'HPC',
        'Distroless': 'Distroless',
        'Others': 'Others',
    }
    category_dir = category_map.get(category, category)

    # Build paths
    app_dir = os.path.join(repo_path, category_dir, app_name)
    version_dir = os.path.join(app_dir, version, oe_version)
    doc_dir_path = os.path.join(app_dir, 'doc')
    picture_dir = os.path.join(doc_dir_path, 'picture')

    try:
        # Create version directory
        os.makedirs(version_dir, exist_ok=True)
        print(f'Created: {version_dir}')

        # Write Dockerfile
        dockerfile_path = os.path.join(version_dir, 'Dockerfile')
        with open(dockerfile_path, 'w') as f:
            f.write(dockerfile_content.rstrip() + '\n')
        created_files.append(dockerfile_path)
        print(f'Written: {dockerfile_path}')

        # Write README.md
        readme_path = os.path.join(app_dir, 'README.md')
        with open(readme_path, 'w') as f:
            f.write(readme_content.rstrip() + '\n')
        created_files.append(readme_path)
        print(f'Written: {readme_path}')

        # Write meta.yml
        meta_path = os.path.join(app_dir, 'meta.yml')
        with open(meta_path, 'w') as f:
            f.write(meta_content.rstrip() + '\n')
        created_files.append(meta_path)
        print(f'Written: {meta_path}')

        # Optional doc directory
        if doc_dir and image_info:
            os.makedirs(picture_dir, exist_ok=True)
            image_info_path = os.path.join(doc_dir_path, 'image-info.yml')
            with open(image_info_path, 'w') as f:
                yaml.dump(image_info, f, default_flow_style=False, allow_unicode=True)
            created_files.append(image_info_path)
            print(f'Written: {image_info_path}')

        # Copy logo if provided
        if logo_path and os.path.exists(logo_path):
            import shutil
            os.makedirs(picture_dir, exist_ok=True)
            logo_ext = os.path.splitext(logo_path)[1]
            dest_logo = os.path.join(picture_dir, f'logo{logo_ext}')
            shutil.copy2(logo_path, dest_logo)
            created_files.append(dest_logo)
            print(f'Copied:  {dest_logo}')

    except OSError as e:
        errors.append(f'Filesystem error: {e}')
    except Exception as e:
        errors.append(f'Unexpected error: {e}')

    return {
        'success': len(errors) == 0,
        'created_files': created_files,
        'errors': errors,
        'paths': {
            'app_dir': app_dir,
            'version_dir': version_dir,
            'dockerfile': os.path.join(version_dir, 'Dockerfile'),
            'readme': os.path.join(app_dir, 'README.md'),
            'meta': os.path.join(app_dir, 'meta.yml'),
        },
    }


def compute_tag(app_version: str, oe_version: str) -> str:
    """Compute the image tag from app version and openEuler version."""
    # Convert oe version to abbreviation
    # e.g., 24.03-lts-sp3 -> oe2403sp3
    #       22.03-lts    -> oe2203lts
    #       25.03         -> oe2503
    import re

    # Match 2-digit year, 2-digit month, optional -lts, optional -spN
    m = re.match(r'(\d{2})\.(\d{2})(?:-lts)?(?:-sp(\d+))?', oe_version)
    if m:
        yy, mm, sp = m.groups()
        abbr = f'oe{yy}{mm}'
        if sp:
            abbr += f'sp{sp}'
        else:
            # If no sp, check if it's an LTS version
            if 'lts' in oe_version.lower():
                abbr += 'lts'
        return f'{app_version}-{abbr}'

    # Fallback: simple substitution
    abbr = oe_version.lower().replace('.', '').replace('-lts-', '').replace('-', '')
    return f'{app_version}-{abbr}'


def main():
    parser = argparse.ArgumentParser(
        description='Generate openEuler container image files')
    parser.add_argument('--app-name', required=True, help='Software name')
    parser.add_argument('--version', required=True, help='Software version')
    parser.add_argument('--category', required=True,
                       help='Category: Bigdata, AI, Storage, Database, Cloud, HPC, Others')
    parser.add_argument('--oe-version', required=True,
                       help='openEuler version (e.g., 24.03-lts-sp3)')
    parser.add_argument('--dockerfile', required=True,
                       help='Path to Dockerfile content file')
    parser.add_argument('--readme', required=True,
                       help='Path to README.md content file')
    parser.add_argument('--meta', required=True,
                       help='Path to meta.yml content file')
    parser.add_argument('--repo-path', required=True,
                       help='Path to openeuler-docker-images repository')
    parser.add_argument('--image-info', help='Path to image-info.yml (optional)')
    parser.add_argument('--logo', help='Path to logo image (optional)')
    parser.add_argument('--dry-run', action='store_true',
                       help='Print what would be done without doing it')

    args = parser.parse_args()

    # Read content files
    with open(args.dockerfile) as f:
        dockerfile_content = f.read()
    with open(args.readme) as f:
        readme_content = f.read()
    with open(args.meta) as f:
        meta_content = f.read()

    image_info = None
    if args.image_info and os.path.exists(args.image_info):
        with open(args.image_info) as f:
            image_info = yaml.safe_load(f)

    tag = compute_tag(args.version, args.oe_version)
    print(f'Tag: {tag}')
    print(f'Path: {args.category}/{args.app_name}/{args.version}/{args.oe_version}/Dockerfile')
    print()

    if args.dry_run:
        print('[DRY RUN] Would create:')
        print(f'  {args.repo_path}/{args.category}/{args.app_name}/{args.version}/{args.oe_version}/Dockerfile')
        print(f'  {args.repo_path}/{args.category}/{args.app_name}/README.md')
        print(f'  {args.repo_path}/{args.category}/{args.app_name}/meta.yml')
        return

    result = create_directory_structure(
        app_name=args.app_name,
        version=args.version,
        oe_version=args.oe_version,
        category=args.category,
        repo_path=args.repo_path,
        dockerfile_content=dockerfile_content,
        readme_content=readme_content,
        meta_content=meta_content,
        doc_dir=bool(args.image_info),
        image_info=image_info,
        logo_path=args.logo,
    )

    if result['errors']:
        print('\nErrors:', file=sys.stderr)
        for e in result['errors']:
            print(f'  - {e}', file=sys.stderr)
        sys.exit(1)

    print(f'\nCreated {len(result["created_files"])} files successfully.')
    print(f'Tag: {tag}')


if __name__ == '__main__':
    main()
