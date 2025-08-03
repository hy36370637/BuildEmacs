#!/bin/bash
# emacs packaging for macOS
###  작업중....  ing

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

# # Emacs 소스코드 클론
# git clone git://git.sv.gnu.org/emacs.git "$dir_name"

# # Emacs 디렉토리로 이동
# cd "$dir_name" || { echo "Failed to enter the $dir_name directory"; exit 1; }

# # autogen 실행
# echo "Running autogen.sh..."
# ./autogen.sh

# 질문 - 소스 다운 or 아닐지 결정(예, pretest처럼 소스 이미 다운했을 경우 'n')
read -p "Would you like to clone and continue from start? (y/n): " answer
if [[ $answer == "y" ]]; then
    # Emacs 소스코드 클론
    git clone git://git.sv.gnu.org/emacs.git "$dir_name"

    # Emacs 디렉토리로 이동
    cd "$dir_name" || { echo "Failed to enter the $dir_name directory"; exit 1; }
fi
echo "Running autogen.sh..."
./autogen.sh
# fi

# configure 실행
echo "Configuring Emacs build options..."

#### jpeg만 포함 - normal
 export CFLAGS="-O3 -march=native -I/opt/homebrew/opt/jpeg/include"
 export LDFLAGS="-O3 -L/opt/homebrew/opt/jpeg/lib"

#### imagemagick 포함, 전부 - ALL
#PKG_CONFIG_PATH="/opt/homebrew/opt/imagemagick/lib/pkgconfig" # brew --prefix imagemagick  위치알기

export PKG_CONFIG_PATH="/opt/homebrew/opt/imagemagick/lib/pkgconfig"

export CPPFLAGS="\
-I/opt/homebrew/opt/imagemagick/include/ImageMagick-7 \
-I/opt/homebrew/opt/jpeg/include \
-I/opt/homebrew/opt/libpng/include \
-I/opt/homebrew/opt/libtiff/include \
 -I/opt/homebrew/opt/webp/include"

export CFLAGS="-O3 -march=native $CPPFLAGS"

export LDFLAGS="\
-L/opt/homebrew/opt/imagemagick/lib \
-L/opt/homebrew/opt/jpeg/lib \
-L/opt/homebrew/opt/libpng/lib \
-L/opt/homebrew/opt/libtiff/lib \
-L/opt/homebrew/opt/webp/lib"

 ### imagemagick제외, 대다수 image format 지원 - Semi
#  export CPPFLAGS="\
# -I/opt/homebrew/opt/jpeg/include \
# -I/opt/homebrew/opt/libpng/include \
# -I/opt/homebrew/opt/libtiff/include \
# -I/opt/homebrew/opt/webp/include"
 
# export CFLAGS="-O3 -march=native $CPPFLAGS"

# export LDFLAGS="\
# -L/opt/homebrew/opt/jpeg/lib \
# -L/opt/homebrew/opt/libpng/lib \
# -L/opt/homebrew/opt/libtiff/lib \
# -L/opt/homebrew/opt/webp/lib"



####
./configure --with-ns  \
  --without-x --without-dbus --without-gpm --without-pop \
  --without-gsettings --without-compress-install --disable-gc-mark-trace \
  --with-native-compilation

#
# CFLAGS와 LDFLAGS 설정  - 속도 향상위해
    # autogen 실행
    # autogen 실행
# export CFLAGS="-O3 -march=native"   #현재 CPU에 최적화된 코드  
# export LDFLAGS="-O3"                            #가장 높은 수준의 최적화. or  -O2
#./configure --without-x --without-dbus --without-gpm --without-pop --without-gsettings --without-compress-install --disable-gc-mark-trace --with-xwidgets --with-native-compilation --with-ns --with-imagemagick

# make 및 make install 실행
echo "Building and installing Emacs..."
# make && sudo make install
make

# src/emacs -Q 정상동작 / make install 하여 손상된 파일로 실행불가 땐

make install
# sudo codesign --force --deep --sign - nextstep/Emacs.app
# 제어센터-개인정보 & 보안 - 보안-그래도 열기

# 위의 방법 미해결. 게이트키퍼 격리 속성 제거
# sudo xattr -rd com.apple.quarantine /Applications/Emacs.app
## 격리 속성 원상복구
# sudo xattr -w com.apple.quarantine '0081;64b6e2ac;Safari;' /Applications/Emacs.app

# 스크립트 완료 메시지
echo "Emacs build and installation completed successfully!"
