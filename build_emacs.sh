#!/bin/bash
# emacs packaging for macOS

# 현재 날짜를 "YYYYMMDD" 형식으로 가져오기
current_date=$(date +"%Y%m%d")

# 디렉토리 이름 설정
dir_name="emacs"
if [ -d "$dir_name" ]; then
  dir_name="emacs_$current_date"
  echo "Existing directory found. Cloning into $dir_name..."
else
  echo "No existing directory found. Cloning into $dir_name..."
fi

# Emacs 소스코드 클론
git clone git://git.sv.gnu.org/emacs.git "$dir_name"

# Emacs 디렉토리로 이동
cd "$dir_name" || { echo "Failed to enter the $dir_name directory"; exit 1; }

# autogen 실행
echo "Running autogen.sh..."
./autogen.sh

# configure 실행
echo "Configuring Emacs build options..."
./configure --with-ns --without-x --without-dbus --without-gpm --without-makeinfo --without-emacsclient --without-pop --without-gsettings

# make 및 make install 실행
echo "Building and installing Emacs..."
make && sudo make install

# 스크립트 완료 메시지
echo "Emacs build and installation completed successfully!"
