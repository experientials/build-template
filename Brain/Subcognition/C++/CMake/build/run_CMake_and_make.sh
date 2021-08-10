#!/bin/bash
rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake Makefile
cmake ..
if [ $? -eq 0 ]; then
   printf '########################\n\u2714\u2714\u2714 OK \u2714 \u2714 \u2714\n########################\n'
else
   printf '########################\n\u274c\u274c\u274c FAIL \u274c \u274c \u274c\n########################\n'
   exit -1
fi
make
if [ $? -eq 0 ]; then
   printf '########################\n\u2714\u2714\u2714 OK \u2714 \u2714 \u2714\n########################\n'
else
   printf '########################\n\u274c\u274c\u274c FAIL \u274c \u274c \u274c\n########################\n'
   exit -1
fi
./hello-world-openCV
if [ $? -eq 0 ]; then
   printf '########################\n\u2714\u2714\u2714 OK \u2714 \u2714 \u2714\n########################\n'
else
   printf '########################\n\u274c\u274c\u274c FAIL \u274c \u274c \u274c\n########################\n'
   exit -1
fi
