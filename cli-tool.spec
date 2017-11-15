Name:           cli-tool
Version:        0.0.1
Release:        1
License:        Unknown
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Source0:        %{name}.tar.gz
Summary:        awesome CLI tool
Group:          Applications/System
BuildArch:      x86_64

%define debug_package %{nil}

%description
awesome CLI tool

%prep
%setup -q -n packaging

%build

%install
rm -rf $RPM_BUILD_ROOT/*

%{__mkdir} -p ${RPM_BUILD_ROOT}%{_usr}/local/bin

%{__cp} -p \
${RPM_BUILD_DIR}/packaging/cli-tool \
${RPM_BUILD_ROOT}/usr/local/bin/cli-tool

%clean
rm -rf ${RPM_BUILD_ROOT}/*

%files
%defattr(-, root, root)

%attr(0755, root, root) %{_usr}/local/bin/cli-tool
