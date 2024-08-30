#!/bin/bash

# Application name
APP_NAME="ScreenBolt"
# Version number
VERSION=${1:-"1.0.0"}
# Release number
RELEASE="1"
# Architecture
ARCH="x86_64"

# Create directory structure for the RPM package
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
mkdir -p ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}

# Create the directory structure in BUILDROOT
mkdir -p ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/opt/${APP_NAME,,}
mkdir -p ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/share/applications
mkdir -p ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/share/icons/hicolor/256x256/apps
mkdir -p ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/bin

# Copy the entire application directory
cp -R dist/ScreenBolt/* ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/opt/${APP_NAME,,}/

# Create a soft link in /usr/bin
ln -s /opt/${APP_NAME,,}/ScreenBolt ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/bin/${APP_NAME,,}

# Create the .desktop file
cat << EOF > ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/share/applications/${APP_NAME,,}.desktop
[Desktop Entry]
Name=$APP_NAME
Exec=/usr/bin/${APP_NAME,,}
Icon=${APP_NAME,,}
Type=Application
Categories=Utility;
EOF

# Copy the icon
cp ../../screenbolt/resources/icons/screenbolt.png ~/rpmbuild/BUILDROOT/${APP_NAME}-${VERSION}-${RELEASE}.${ARCH}/usr/share/icons/hicolor/256x256/apps/${APP_NAME,,}.png

# Create the SPEC file
cat << EOF > ~/rpmbuild/SPECS/${APP_NAME,,}.spec
Name:           ${APP_NAME,,}
Version:        $VERSION
Release:        $RELEASE
Summary:        Screen recording and editing application
License:        Proprietary
URL:            https://example.com/${APP_NAME,,}
BuildArch:      $ARCH

%description
ScreenBolt is a desktop application for screen recording
and video editing, featuring options like background replacement and padding.

%files
%defattr(-,root,root,-)
/opt/${APP_NAME,,}
/usr/bin/${APP_NAME,,}
/usr/share/applications/${APP_NAME,,}.desktop
/usr/share/icons/hicolor/256x256/apps/${APP_NAME,,}.png

%post
/bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :
/usr/bin/update-desktop-database &>/dev/null || :

%postun
if [ $1 -eq 0 ] ; then
    /bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    /usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi
/usr/bin/update-desktop-database &>/dev/null || :

EOF

# Build the RPM package
rpmbuild -bb ~/rpmbuild/SPECS/${APP_NAME,,}.spec

echo "RPM package created: ~/rpmbuild/RPMS/${ARCH}/${APP_NAME,,}-${VERSION}-${RELEASE}.${ARCH}.rpm"