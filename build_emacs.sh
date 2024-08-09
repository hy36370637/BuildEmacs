#!/bin/bash
# emacs packaging for macOS

# Emacs 소스코드 클론
echo "Cloning Emacs repository..."
git clone git://git.sv.gnu.org/emacs.git

# Emacs 디렉토리로 이동
cd emacs || { echo "Failed to enter the emacs directory"; exit 1; }

# autogen 실행
echo "Running autogen.sh..."
./autogen.sh

# configure 실행
echo "Configuring Emacs build options..."
./configure --with-ns --without-x --without-dbus --without-gpm --without-makeinfo --without-emacsclient --without-pop --without-gsettings

# make 및 make install 실행
echo "Building and installing Emacs..."
make && make install

# 스크립트 완료 메시지
echo "Emacs build and installation completed successfully!"
