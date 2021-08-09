# Compile on docker container

* We can compile on docker arm64 by running `docker run --rm -it -v host/path/to/Subcognition:/Subcognition -w="/Subcognition/C++/CMake/build" --platform arm64  docker.io/alexlyrakis/subcognition_toolchain:latest /bin/bash /Subcognition/C++/CMake/build/run_CMake_and_make.sh`

*Important!** If you cannot execute arm containers on x86_64 Linux system, then run the following `docker run --rm --privileged linuxkit/binfmt:v0.8`. This should setup the binfmt and QEMU.

# Test on GitHub Actions
