#!/bin/bash
set -euo pipefail

#apply patches for linux builds
file=$1
if [ ! -f "$file" ]; then
  echo "Error: The patch file: $file not exist."
  exit 1
fi

# Apply patches
echo "Applying patch"
git apply --ignore-space-change --ignore-whitespace --whitespace=nowarn "${file}"

if [ "$#" -le 0 ]; then
        echo "./rpmbuild.sh xx.xx.xx.xxxx purley | whitley"
        exit 3
fi

BUILDNUM=$2
SOURCEDIR=$PWD

# remove all rpmbuild
rm -rf $SOURCEDIR/output/rpmbuild

# Make directories
mkdir -p $SOURCEDIR/output/rpmbuild
mkdir -p $SOURCEDIR/output/rpmbuild/BUILDROOT
mkdir -p $SOURCEDIR/output/rpmbuild/SOURCES
mkdir -p $SOURCEDIR/output/rpmbuild/RPMS
mkdir -p $SOURCEDIR/output/rpmbuild/SRPMS
mkdir -p $SOURCEDIR/output/rpmbuild/SPECS
mkdir -p $SOURCEDIR/output/rpmbuild/ipmctl-$BUILDNUM

# Copy spec file
cp install/linux/rel-release/ipmctl.spec.in $SOURCEDIR/output/rpmbuild/SPECS/ipmctl.spec


# Update the spec file with build version
sed -i "s/^%define build_version .*/%define build_version $BUILDNUM/g" $SOURCEDIR/output/rpmbuild/SPECS/ipmctl.spec

# Archive the directory
tar --exclude-vcs --exclude="*output" --exclude="*.swp*" --transform="s,^.,ipmctl-$BUILDNUM," -zcf $SOURCEDIR/output/rpmbuild/SOURCES/ipmctl-$BUILDNUM.tar.gz .

# rpmbuild
rpmbuild -ba $SOURCEDIR/output/rpmbuild/SPECS/ipmctl.spec --define "_topdir $SOURCEDIR/output/rpmbuild"