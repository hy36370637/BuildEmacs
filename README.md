# Builder script for Emacs
Personally, I want a small and fast package by excluding unnecessary things.
## 재컴파일 방법
 - cd source
 - make clean
 - ./configure -with-ns
 - make && make install
 ### 손상된 패키지 애러
 - make 후 src/emacs -Q 정상 실행한 것 확인
 - make install 후 손상된 패키지.  불가 대처
# sudo codesign --force --deep --sign - nextstep/Emacs.app
 
※ "I'm using macOS."
