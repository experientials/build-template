# ARM Embedded Firmware build setup for Rust & C++

The firmware is built from C, C++ and Rust source code. It produces multiple binaries. The binaries are bundled in OPKG packages and can be run in Docker containers using simple command line scripts.

The firmware runs on OpenWRT on the real devices, and should run on something similar such as Alpine on docker.

For continuous integration builds the changes are built and copied to a docker container. 
Tests are run and if successful the container is pushed to Docker Hub.

The aim is to produce software that can be run on:

![Raspberry Pi](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fdlitetech.com%2Fwp-content%2Fuploads%2F2020%2F05%2FRaspberry-Pi-4-Model-B.jpg&f=1&nofb=1)
Raspberry Pi 3+ (Raspbian or OpenWRT?)

![Maix II](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.cnx-software.com%2Fwp-content%2Fuploads%2F2021%2F01%2FMAIX-II-Dock.jpg&f=1&nofb=1)
Allwinner V831 / Sipeed Maix II (Tina Linux)

When available the main platform will be Rockchip RV1126 with OpenWRT.


## The tasks

You must solve the following tasks

- Configure Docker containers needed
- Configure Rust toolchain to use
- Configure C++ toolchain to use
- Make it build binaries for ARMv7
- Make docker container that can run the binaries
- Build ipk package files that extract to the correct locations
- Make the build include static asset files from source in ipk package files
- Build for Loader package & binary
- Build for Subcognition package & binary
- Build for Awareness package & binary
- Running video inputting stream to the ARM docker container
- Record the event log from the ARM docker container
- Validate the recorded event log against expectation
- GitHub Actions CI config
- Document how to use
- Deliver all work as Pull Requests to a GitHub repo


## System Endgoal

In the ultimate system:

A single git repository holds multiple directories under `/Brain` with `CMake.txt` or `Cargo.toml`.
These directories are compiled as projects to produce binaries. The binaries are combined with static
files and bundled into packages.

The `main` branch contains the latest successful change.
Changes are pushed to the `stage` branch. On new pushes the CI kicks in building a new release.
If successfully built the changes are merged into the `main` branch.

Tests verify the packages installed in the system responding to video and audio input as expected.
A video is run and an expected event log compared with the one recorded during the run.

A public package repository hosts(webhost) all packages from successful builds in a structure usable by
OpenWRT or Alpine Linux installation.
The package repository is divided into streams `alpha`, `beta` and `stable`. New releases start in the alpha stream, as they prove stability on real devices they are introduced in the beta and stable streams.

A dedicated uboot codebase is held in a sub-repository and built together with the packages.


## Directory Structure

Build is triggered based on the top directory. It is run in docker with `/home` being mapped to the docker container using `docker buildx`. The steps are `compile`, `bundle`, `deploy`, `test`, `publish`.

The home folder must be on a case sensitive file system. This can be achieved by cloning the git repository on a case sensitive volume, or by symlinking home folder to a location on a case sensitive volume.

- NormallyClosed is a rust example package. It will not be part of the real build.
- Loader is a binary only C++ or Rust package. The output is a binary file in root /Loader.bin
- Subcognition is a Rust package. The output is an OPKG package expanded in /usr.
- Awareness is a mix of C++ and Python. The output is an OPKG package expanded in /usr. It provides bindings to C++ libraries.


## Target Platforms

The real targets are embedded ARM systems, but a future version may also be RISC-V.
Using docker an emulated target must also be supported. 
The instruction set at this moment is ARMv7.

- Allwinner V833
- Allwinner V831
- Rockchip RV1126 (Primary target)
- Raspberry Pi3+
- Mac OS Docker
- Linux PC Docker (Alpine or Ubuntu)

The hardware will end up being custom, but to begin with we have to run against dev boards and maker products
such as Sipeed Maix-II & Maix-II-S. I'm trying to get some Firely dual camera modules as well based on RV1126.


## Dependencies

OpenCV ([opencv-rust](https://github.com/twistedfall/opencv-rust)) must be available as an dependency packaged in the build.

The camera video stream must be working for environment on Raspberry Pi, and ultimately on V831 and RV1126.

The OpenWRT installation will contain the modules listed in [Package Mirror](http://mirror.sipeed.com/maix_ii/base/).

Python bindings written in C++ can be laid out similar to [libmaix](https://github.com/sipeed/libmaix)
unless a better structure is found.



## Deploy

One or more ARM docker containers must be defined so the build output can be integration tested
running with an emulating docker container on a PC.

The docker setup has a native docker container for cross compiling binaries to the embedded platform
and an emulated docker container for testing the packages in a similar environment. The emulated
docker container connects to simulated devices for audio and video input. Up to two video cameras
can be simulated.


## Publishing

The successful builds should be published to docker hub with a unique release number.


## Continuous Build

1. Check that `main` branch can be fast forwarded to `stage` branch. If not fail with message.
2. Identify the next release number based on release tags on the `main` branch.
3. Compile source code for the packages to binaries. If issue fail with message.
4. Construct ipk packages from source and built binaries using the next available release number.
5. Run the ARM docker container and install the built images
6. Run tests on the ARM docker feeding mock audio and video devices
7. If tests fail stop here with message.
8. Fast forward `main` to the `stage` commit that has passed the tests.
9. Tag the new commit on `main` branch with a version tag and a release tag E.g. `v1.99` and `r99`.
10. Push the created ARM docker image to docker hub using the version number.
11. Push the generated packages to the package repository using the version number.

Packages use a major.release version scheme. The major version is defined in source code.
The release number is allocated incrementally and set as a tag on `main` branch commits.
The version number is common the all packages and the resulting docker image.

Tests verify the packages installed in the system responding to video and audio input as expected.
A video is run and an expected event log compared with the one recorded during the run.

