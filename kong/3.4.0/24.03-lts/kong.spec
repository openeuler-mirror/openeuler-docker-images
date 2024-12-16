# update the bazel version if nessary when kong version changes
%global bazel_version 6.1.0
%global debug_package %{nil}
# You need to set the GITHUB_TOKEN environment variable to a valid GitHub personal access token
%global github_token ${GITHUB_TOKEN}

Name:           kong
Version:        ${kong_version}
Release:        1
Summary:        Kong Gateway - Open source API Gateway and Microservices Management Layer
License:        Apache License 2.0
URL:            https://github.com/Kong/kong

%ifarch x86_64
    %global build_arch x86_64
%elifarch aarch64
    %global build_arch arm64
%else
    echo "unsupport arch..."
%endif

# Source here
Source0:        %{name}-%{version}.tar.gz
Source1:        https://mirrors.huaweicloud.com/bazel/%{bazel_version}/bazel-%{bazel_version}-linux-%{build_arch} 
# Patch here
Patch0:         bazel-build-%{version}.patch

# Build dependencies
BuildRequires:  gcc
BuildRequires:  gcc-c++
BuildRequires:  make
BuildRequires:  patch
BuildRequires:  unzip

# Runtime dependencies
Requires:       openssl
Requires:       zlib
Requires:       pcre
Requires:       zlib-devel
Requires:       pcre-devel
Requires:       libyaml-devel
Requires:       openssl-devel

%description
Kong is an open-source API Gateway and Microservices Management Layer, delivering high performance and reliability.

%prep
%autosetup -n %{name}-%{version} -p1

%build
chmod 755 %{_sourcedir}/bazel-%{bazel_version}-linux-%{build_arch}
cp -ar %{_sourcedir}/bazel-%{bazel_version}-linux-%{build_arch} /usr/bin/bazel

%install
export GITHUB_TOKEN=%{github_token}
make package/rpm
mkdir -p %{_rpmdir}/%{build_arch}
cp %{_builddir}/kong-${kong_version}/bazel-bin/pkg/kong*.rpm %{_rpmdir}/%{build_arch}/

# update when you build a new version
%changelog
* Fri Dec 06 2024 You name <You Email> - ${kong_version}-1
- Initial RPM package for Kong ${kong_version}