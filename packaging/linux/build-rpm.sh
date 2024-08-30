#!/bin/bash

# Package name (lowercase for package name, command name)
PKG_NAME="screenbolt"
# Display name
DISPLAY_NAME="ScreenBolt"

# Version number
VERSION=${1:-"1.0.0"}
# Release number
RELEASE="1"
# Architecture
ARCH="x86_64"

# Create directory structure for the RPM package
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
mkdir -p ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}

# Create the directory structure in BUILDROOT
mkdir -p ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/opt/${PKG_NAME}
mkdir -p ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/share/applications
mkdir -p ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/share/icons/hicolor/256x256/apps
mkdir -p ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/bin

# Copy the entire application directory
cp -R dist/${DISPLAY_NAME}/* ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/opt/${PKG_NAME}/

# Create a soft link in /usr/bin
ln -s /opt/${PKG_NAME}/${DISPLAY_NAME} ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/bin/${PKG_NAME}

# Create the .desktop file
cat << EOF > ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/share/applications/${PKG_NAME}.desktop
[Desktop Entry]
Name=${DISPLAY_NAME}
Exec=/usr/bin/${PKG_NAME}
Icon=${PKG_NAME}
Type=Application
Categories=Utility;
EOF

# Copy the icon
cp ../../screenbolt/resources/icons/screenbolt.png ~/rpmbuild/BUILDROOT/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png

# Create the SPEC file
cat << EOF > ~/rpmbuild/SPECS/${PKG_NAME}.spec
Name:           ${PKG_NAME}
Version:        $VERSION
Release:        $RELEASE
Summary:        Screen recording and editing application
License:        Proprietary
URL:            https://www.screenbolt.com
BuildArch:      $ARCH

%description
${DISPLAY_NAME} is a desktop application for screen recording
and video editing, featuring options like background replacement and padding.

%files
%defattr(-,root,root,-)
/opt/${PKG_NAME}
/usr/bin/${PKG_NAME}
/usr/share/applications/${PKG_NAME}.desktop
/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png

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
rpmbuild -bb ~/rpmbuild/SPECS/${PKG_NAME}.spec

# Move the RPM to the current directory
RPM_FILE=~/rpmbuild/RPMS/${ARCH}/${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}.rpm
if [ -f "$RPM_FILE" ]; then
    mv "$RPM_FILE" .
    echo "RPM package created and moved: ${PKG_NAME}_${VERSION}_${RELEASE}.${ARCH}.rpm"
else
    echo "Error: RPM file not found at $RPM_FILE"
    exit 1
fi