Summary:	The Texinfo package contains programs for reading, writing, and converting info pages. 	
Name:		tools-texinfo
Version:	6.4
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/texinfo
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://ftp.gnu.org/gnu/texinfo/texinfo-%{version}.tar.xz
%description
	The Texinfo package contains programs for reading, writing, and converting info pages. 
%prep
%setup -q -n texinfo-%{version}
%build
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}/tools/share/info
	rm -rf %{buildroot}/tools/share/man
	rm -rf %{buildroot}/tools/share/locale
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 6.4-1
-	LFS-8.1