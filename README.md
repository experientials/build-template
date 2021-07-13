# Firmware Template

Automates the build of multiple packages forming the `/Brain`. The software built is for [Ziloo](https://github.com/thepian/ziloo)

To clone the repository remember submodules and use `git clone --recurse-submodules https://github.com/experientials/build-template`.


## Target Platforms

The aim is to produce software that can be run on embedded systems:

![Maix II](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.cnx-software.com%2Fwp-content%2Fuploads%2F2021%2F01%2FMAIX-II-Dock.jpg&f=1&nofb=1)
Allwinner V831 / Sipeed Maix II (Tina Linux)

![Maix IIS / M2S](https://pbs.twimg.com/media/E2X5BrsUYAAY-8k?format=jpg&name=large)
Allwinner V833 / Sipeed Maix IIS (Tina Linux)

![Maix III / M3](https://www.cnx-software.com/wp-content/uploads/2021/01/Sipeed-MAIX-III-768x488.jpg.webp)
Rockchip RV1126 (Primary target)

![Raspberry Pi](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fdlitetech.com%2Fwp-content%2Fuploads%2F2020%2F05%2FRaspberry-Pi-4-Model-B.jpg&f=1&nofb=1)
Raspberry Pi 3+ (Raspbian or OpenWRT?)

![Firefly CAM-C1126S2U](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.EzfJ6LCXsEVDT_LAncdecQHaEV%26pid%3DApi&f=1)
Rockchip RV1126 based

The two main options intended to be used in the finished product are V833 and RV1126. The other platforms
are intended to be experimental.

In order to test and develop software that is abstracted from the hardware Docker containers
are run on Mac OS and Linux. 


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

# Reading List

In order to understand and develop consider the following.


## Build System

Virtual Camera on Linux [Webcamoid](https://webcamoid.github.io)
[akvcam, Virtual camera driver for Linux](https://github.com/webcamoid/akvcam)
[Wiki](https://github.com/webcamoid/webcamoid/wiki).

[GitHub Actions](https://github.com/features/actions) are used to trigger building, testing and release.

Docker Buildx 
[Doc](https://docs.docker.com/buildx/working-with-buildx/) 
[Github Action](https://github.com/marketplace/actions/docker-buildx)

Rust builds
[with Cargo Chef](https://www.lpalmieri.com/posts/fast-rust-docker-builds/)
[Multi stage docker](https://dev.to/deciduously/use-multi-stage-docker-builds-for-statically-linked-rust-binaries-3jgd)
[Cross-compiling static Rust binaries in Docker for Raspberry Pi](https://jakewharton.com/cross-compiling-static-rust-binaries-in-docker-for-raspberry-pi/)

[Musl libc](https://wiki.musl-libc.org/projects-using-musl.html) must be used to compile packages.


## Base Operating System

OpenWRT [RPi Download](https://openwrt.org/toh/raspberry_pi_foundation/raspberry_pi)
[Buildroot](https://openwrt.org/docs/techref/buildroot)
[UVC Driver](https://openwrt.org/docs/guide-user/hardware/video/webcam)
[Opkg package manager](https://openwrt.org/docs/guide-user/additional-software/opkg)

Buildroot [Documentation](https://buildroot.org)

U-Boot 
[Intro](http://www.denx.de/wiki/U-Bootdoc/Presentation)
[Documentation](http://www.denx.de/wiki/U-Boot/Documentation) 

## Subcognition

- [Motion-detector for moving camera on OpenCV](https://stackoverflow.com/questions/28308057/motion-detector-for-moving-camera-on-opencv)


## Various

- [USB Boot on raspberry pi](https://github.com/raspberrypi/usbboot)
- [SD Card Etcher Pro x16](https://www.balena.io/etcher/pro)
