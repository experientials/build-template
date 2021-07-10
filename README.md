# Firmware Template

Automates the build of multiple packages forming the `/Brain`.


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
