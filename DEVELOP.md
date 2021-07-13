
# Writing SD Card

For development the system must be run on and from an SD card.

- [Create SD Card](#create-sd-card)
- [Update, Set Password & Enable WiFi](#first-run)
- [Connect via ftp](#ftp-access)
- [Zeroconf / mDNS](#mdns-setup)
- [SSH Config](#ssh-config)
- [OpenCV](#opencv)
- [Preparing USB SD Card on MacOS](#preparing-usb-sd-card-on-macos)
- [Writing USB SD Card Ubuntu](#writing-usb-sd-card-ubuntu)


## Partition Map

The real partition map has to be defined. The card created by LiveSuit must be taken apart to determine
how it is all constructed

TODO the map

Assumption based on regular OpenWRT:

* First 8k: Unused, available for partition table etc.
* Next 24k: Initial SPL loader
* Next 512k: u-boot
* Next 128k: environment
* Next 352KB: reserved
* Offset 1Mb: Partitions

This doesn't work with images from dl.sipeed.com since it is for LiveSuit

> sudo dd if=Downloads/u-boot-sunxi-with-spl-vga.bin of=/dev/sdb bs=1024 seek=8
> sudo diskutil unmountDisk disk3
> sudo dd if=firmware/MaixPy3/tina_v831-sipeed_uart0-2.img of=/dev/rdisk3s1 bs=1024


## Create SD Card

Use [LiveSuit on Linux](https://github.com/junhuanchen/sunxi-livesuite). This is patched for Maix/Sunxi.
Follow the [instructions](https://maixpy.sipeed.com/maixpy3/zh/install/maixii_m2dock/flash.html) exactly

LiveSuit is developed by Allwinner for Windows and Linux. The MacOS version is dodgy.
Unfortunately it seems to require running on Ubuntu 20.10.
It needs packages `sudo apt install libtool git`. Other links,

- [LiveSuit for MacOS](http://www.mediafire.com/file/haab4na4e8gsqgo/LiveSuit_V305_For_MacOSX_org.zip/file) does not seem to work.
- [LiveSuit product page](https://linux-sunxi.org/LiveSuit).
- [GitHub](https://github.com/linux-sunxi/sunxi-livesuite)
- [For MAIX-II](https://github.com/junhuanchen/sunxi-livesuite) is the one to use.


## First Run

- Configure `minicom -s`. Set meta key. Set modem device = /dev/tty.usbserial-14100
- Connect via UART `minicom`
- call `maix3_config.sh` configure
- Set root/turkey is for dinner
- Not the active ip address with `ifconfig`.


## FTP Access

You can connect to a server in Finder via ftp://root@192.168.1.76 or the ip address active.

SFTP Server

https://openwrt.org/docs/guide-user/services/nas/sftp.server

> opkg update
> opkg install openssh-sftp-server
> opkg install announce


## mDNS Setup

https://openwrt.org/docs/guide-developer/mdns


## SSH Config

Dropbear based `/etc/config/dropbear`. More at `/etc/dropbear`.

https://openwrt.org/docs/guide-user/base-system/dropbear

https://matt.ucc.asn.au/dropbear/dropbear.html

https://www.real-world-systems.com/docs/uci.1.html

https://serverfault.com/questions/545476/add-authentication-keys-to-dropbear-ssh

- authorized_keys
- X11 forwarding


## OpenCV

> opkg update && opkg install opencv

```
opkg install http://mirror.sipeed.com/maix_ii/base/fontconfig_2.12.1-3_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/glib2_2.50.1-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/libcairo_1.14.6-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/icu_55.1-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/libwebp_0.4.3-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/harfbuzz_1.7.4-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/libAWIspApi_1-1_sunxi.ipk
opkg install http://mirror.sipeed.com/maix_ii/base/opencv_4.1.0_sunxi.ipk
```


## Preparing USB SD Card on MacOS

TODO scripted on MacOS

Check the sector size
> diskutil info disk3

Format on Mac
> diskutil partitionDisk disk3 MBR JHFS+ Boot 2G ExFAT Shared 1G

On Mac check the formatting of the SD Card

```
$ sudo fdisk /dev/disk3
Disk: /dev/disk3	geometry: 1936/255/63 [31116288 sectors]
Signature: 0xAA55
         Starting       Ending
 #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
 1: 0C    0 130   3 - 1023 254  63 [      8192 -   31108096] Win95 FAT32L
 2: 00    0   0   0 -    0   0   0 [         0 -          0] unused      
 3: 00    0   0   0 -    0   0   0 [         0 -          0] unused      
 4: 00    0   0   0 -    0   0   0 [         0 -          0] unused   
```




## Writing USB SD Card Ubuntu

TODO scripted instead of LiveSuit
TODO Working on Raspberry Pi hardware

There are guides to follow. Varying quality,

* [Orange Pi](http://www.orangepi.org/Docs/Settingup.html)
* [Allwinner Linux](https://linux-sunxi.org/Bootable_SD_card) 
* [OpenWRT](https://openwrt.org/docs/techref/hardware/soc/soc.allwinner.sunxi#installing_openwrt) 

Sector/Block Size = 512 (bs=512) for 16Gb
Partition Map = MBR Master Boot Record

Linux device `sdb`. Partition 1 `sdb1`, partition 2 `sdb2`.

V831: ARM Cortex Single A7 


# OPKG Package List of Installation

## All Packages

http://mirror.sipeed.com/maix_ii/base/

Should packages be gotten elsewhere?

Ziloo Packages host needed.


## Packages Installed

> root@sipeed:/# opkg list


```
MaixPy3 - 0.2.5-1 - a cross-platform package with c & py.
alsa-lib - 1.1.4.1-1 - This is the library package for alsa, needed by some userspace programs.
 You must have enabled the ALSA support in the kernel.
alsa-utils - 1.1.0-1 - ALSA (Advanced Linux Sound Architecture) utilities
busybox - 1.27.2-3 - The Swiss Army Knife of embedded Linux.
 It slices, it dices, it makes Julian Fries.
busybox-init-base-files - 167-1612350358
busybox-init-base-files - 167-1612257817 - This package contains a busybox init base filesystem and system scripts f.
ca-certificates - 20160104 - System CA certificates
camerademo - 1.0-1 - camerademo test sensor
curl - 7.54.1-1 - A client-side URL transfer utility
dropbear - 2015.71-2 - A small SSH2 server/client designed for small memory environments.
e2fsprogs - 1.42.12-1 - This package contains essential ext2 filesystem utilities which consists of
 e2fsck, mke2fs and most of the other core ext2 filesystem utilities.
eyesee-mpp-external - 1.0-1 - eyesee-mpp-external contains some external libs which are needed by other mpp modules.
eyesee-mpp-middleware - 1.0-1 - eyesee-mpp-middleware contain eyesee-mpp basic libraries.
eyesee-mpp-system - 1.0-1 - eyesee-mpp-system is as eyesee-mpp low level libraries.
fbviewer - 1 - Frame buffer viewer image
fontconfig - 2.12.1-3 - The Fontconfig package contains a library and support programs used for
 configuring and customizing font access.
glib2 - 2.50.1-1 - The GLib library of C routines
glog - 0.3.5-2 - This repository contains a C++ implementation of the Google logging
 module.  Documentation for the implementation is in doc/.
harfbuzz - 1.7.4-1 - HarfBuzz is an OpenType text shaping engine.
hostapd-common - 2017-11-08-2 - hostapd/wpa_supplicant common support files
i2c-tools - 3.1.2-1 - This package contains an heterogeneous set of I2C tools for Linux. These tools
 were originally part of the lm-sensors package.
icu - 55.1-1 - International Components for Unicode
iperf3 - 3.0.11-1 - Iperf is a modern alternative for measuring TCP and UDP bandwidth
 performance, allowing the tuning of various parameters and
 characteristics.
jshn - 2016-02-26-5326ce1046425154ab715387949728cfb09f4083 - Library for parsing and generating JSON from shell scris
jsonfilter - 2014-06-19-cdc760c58077f44fc40adbbe41e1556a67c1b9a9 - OpenWrt JSON filter utility
kernel - 4.9.118-1-c166dfd81804ce13f1769d26dc1448a4
kmod-8189fs - 4.9.118-1 - 8189fs support (staging)
kmod-cfg80211 - 4.9.118-1 - Kernel modules for CFG80211 support
kmod-spi-dev - 4.9.118-1 - This package contains the user mode SPI device driver
kmod-vin-v4l2 - 4.9.118-1 - Video input support (staging)
libAWIspApi - 1-1 - camera VIN ISP api for allwinner
libattr - 20150922-1 - Extended attributes support
 This package provides libattr
libblobmsg-json - 2016-02-26-5326ce1046425154ab715387949728cfb09f4083 - blobmsg <-> json conversion library
libbz2 - 1.0.6-2 - bzip2 is a freely available, patent free, high-quality
 data compressor. This packages provides libbz2 library.
libc - -1
libcairo - 1.14.6-1 - Cairo is a 2D graphics library with support for multiple output devices.
 Currently supported output targets include the X Window System (via both Xlib and XCB).
 Quartz, Win32, image buffers, PostScript, PDF, and SVG file output.
 Experimental backends include OpenGL, BeOS, OS/2, and DirectFB.
 
 Cairo is designed to produce consistent output on all output media while
 taking advantage of display hardware acceleration when available
 (eg. through the X Render Extension).
libcurl - 7.54.1-1 - A client-side URL transfer library
libdb47 - 4.7.25.4.NC-5 - Berkeley DB library (4.7).
libexpat - 2.1.0-3 - A fast, non-validating, stream-oriented XML parsing library.
libext2fs - 1.42.12-1 - libext2fs is a library which can access ext2, ext3 and ext4 filesystems.
libffi - 3.0.13-1 - The libffi library provides a portable, high level programming interface to
 various calling conventions. This allows a programmer to call any function
 specified by a call interface description at run-time.
 
 FFI stands for Foreign Function Interface. A foreign function interface is the
 popular name for the interface that allows code written in one language to call
 code written in another language. The libffi library really only provides the
 lowest, machine dependent layer of a fully featured foreign function interface.
 A layer must exist above libffi that handles type conversions for values passed
 between the two languages.
libfreetype - 2.5.5-2 - The FreeType project is a team of volunteers who develop free,
 portable and high-quality software solutions for digital typography.
 They specifically target embedded systems and focus on bringing small,
 efficient and ubiquitous products.
libgcc - -1 - GCC support library
libgdbm - 1.11-1 - GNU database manager library
 GNU dbm is a set of database routines that use extendible hashing and
 works similar to the standard UNIX dbm routines.
libjpeg - 9a-1 - The Independent JPEG Group's JPEG runtime library
libjson-c - 0.12-1 - This package contains a library for javascript object notation backends.
libjson-script - 2016-02-26-5326ce1046425154ab715387949728cfb09f4083 - Minimalistic JSON based scripting engine
liblua - 5.1.5-1 - Lua is a powerful light-weight programming language designed for extending
 applications. Lua is also frequently used as a general-purpose, stand-alone 
 language. Lua is free software.
 This package contains the Lua shared libraries, needed by other programs.
liblzma - 5.2.2-1 - liblzma library from XZ Utils
libmaix - 0.0.1-1 - maix middleware libs
libncurses - 5.9-3 - Terminal handling library
libncursesw - 5.9-3 - Terminal handling library (Unicode)
libnghttp2 - 1.24.0 - tools in nghttp2, eg: nghttp nghttpd nghttpx h2load
 details see libnghttp2
libnl-tiny - 0.1-5 - This package contains a stripped down version of libnl
libopenssl - 1.1.0i-1 - The OpenSSL Project is a collaborative effort to develop a robust,
 commercial-grade, full-featured, and Open Source toolkit implementing the
 Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols as well
 as a full-strength general-purpose cryptography library.
 This package contains the OpenSSL shared libraries, needed by other programs.
libpcre - 8.38-2 - A Perl Compatible Regular Expression library
libpixman - 0.34.0-1 - Pixman is a low-level software library for pixel manipulation
libpng - 1.2.56-1 - A PNG format files handling library
libpthread - -1 - POSIX thread library
libreadline - 6.3-1 - The Readline library provides a set of functions for use by applications
 that allow users to edit command lines as they are typed in. Both Emacs 
 and vi editing modes are available. The Readline library includes 
 additional functions to maintain a list of previously-entered command 
 lines, to recall and perhaps reedit those lines, and perform csh-like 
 history expansion on previous commands.
librt - -1 - POSIX.1b RealTime extension library
libsqlite3 - 3120200-1 - SQLite is a small C library that implements a self-contained, embeddable,
 zero-configuration SQL database engine.
 This package contains the SQLite (v3.x) shared library, used by other
 programs.
libstdcpp - -1 - GNU Standard C++ Library v3
libuapi - 1-1 - unit api for allwinner
libubox - 2016-02-26-5326ce1046425154ab715387949728cfb09f4083 - Basic utility library
libubus - 2016-01-26-619f3a160de4f417226b69039538882787b3811c - OpenWrt RPC client library
libuci - 2016-02-02.1-1 - C library for the Unified Configuration Interface (UCI)
libuclient - 2016-01-28-2e0918c7e0612449024caaaa8d44fb2d7a33f5f3 - HTTP/1.1 client library
libuuid - 2.25.2-4 - The UUID library is used to generate unique identifiers for objects
 that may be accessible beyond the local system. This library
 generates UUIDs compatible with those created by the Open Software
 Foundation (OSF) Distributed Computing Environment (DCE) utility.
libwebp - 0.4.3-1 - webp libraries
libxml2 - 2.9.3-1 - A library for manipulating XML and HTML resources.
logd - 2016-03-07-fd4bb41ee7ab136d25609c2a917beea5d52b723b - OpenWrt system log implementation
lrzsz - 0.12.20-2 - Transfer files in your login sessions.
 Very leightweight and straight forward.
 You just need a terminal client that can do
 either X, Y or Z-modem file transfers.
micropython - 1.9.4-2 - This package contains Micro Python, a lean and fast implementation of the Python 3.4 programe
 that is optimised to run on a microcontroller (and low power computers).
micropython-lib - 1.9.3-1 - This package contains micropython-lib, a project to develop a non-monolothic
 standard library for Micro Python. Note that this is a work in progress and
 several libraries may be missing, incomplete or buggy.
mtd - 21 - This package contains an utility useful to upgrade from other firmware or
 older OpenWrt releases.
netifd - 2016-02-01-3610a24b218974bdf2d2f709a8af9e4a990c47bd - OpenWrt Network Interface Configuration Daemon
opencv - 4.1.0 - OpenCV (Open Source Computer Vision Library) is an open source computer vision and machine learning.
opkg - 9c97d5ecd795709c8584e972bfdf3aee3a5b846d-10 - Lightweight package management system
 opkg is the opkg Package Management System, for handling
 installation and removal of packages on a system. It can
 recursively follow dependencies and download all packages
 necessary to install a particular package.
 
 opkg knows how to install both .ipk and .deb packages.
python-pip-conf - 0.1-1 - Configuration file for pip/pip3
python3 - 3.8.5-2 - This package contains the (almost) full Python install.
 It's python3-light + all other packages.
python3-asyncio - 3.8.5-2 - Python 3.8 asyncio module
python3-base - 3.8.5-2 - This package contains only the interpreter and the bare minimum
 for the interpreter to start.
python3-certifi - 2020.6.20-1 - Certifi is a carefully curated collection of Root Certificates for validating the
 trustworthiness of SSL certificates while verifying the identity of TLS hosts.
python3-cgi - 3.8.5-2 - Python 3.8 cgi module
python3-cgitb - 3.8.5-2 - Python 3.8 cgitb module
python3-chardet - 3.0.4-4 - Universal encoding detector for Python 2 and 3
python3-codecs - 3.8.5-2 - Python 3.8 codecs + unicode support
python3-ctypes - 3.8.5-2 - Python 3.8 ctypes module
python3-dbm - 3.8.5-2 - Python 3.8 dbm module
python3-decimal - 3.8.5-2 - Python 3.8 decimal module
python3-distutils - 3.8.5-2 - Python 3.8 distutils module
python3-email - 3.8.5-2 - Python 3.8 email module
python3-evdev - 1.4.0-2 - Bindings to the Linux input handling subsystem
python3-gdbm - 3.8.5-2 - Python 3.8 gdbm module
python3-gpiod - 1.4.0-2 - A fast and complete Python implementation of gpiod.
python3-idna - 2.10-1 - A library to support the Internationalised Domain Names in Applications
 (IDNA) protocol as specified in RFC 5891. This version of the protocol
 is often referred to as "IDNA2008" and can produce different results
 from the earlier standard from 2003.
python3-light - 3.8.5-2 - This package is essentially the python3-base package plus
 a few of the rarely used (and big) libraries stripped out
 into separate packages.
python3-logging - 3.8.5-2 - Python 3.8 logging module
python3-lzma - 3.8.5-2 - Python 3.8 lzma module
python3-multiprocessing - 3.8.5-2 - Python 3.8 multiprocessing
python3-ncurses - 3.8.5-2 - Python 3.8 ncurses module
python3-numpy - 1.19.2-1 - NumPy is the fundamental package for array computing with Python.
 
 By default, this package is built without some modules.
 For some modules to be available, the INSTALL_GFORTRAN symbol needs
 to be enabled in the OpenWrt core/toolchain.
python3-openssl - 3.8.5-2 - Python 3.8 SSL module
python3-pillow - 7.2.0-1 - The friendly PIL fork
python3-pip - 20.1.1-1 - Python 3.8 pip module
python3-pkg-resources - 47.1.0-1 - Python 3.8 pkg_resources module (part of setuptools)
python3-plumbum - 1.6.9-2 - A fast and complete Python implementation of plumbum.
python3-pyasn1 - 0.4.8-2 - This is an implementation of ASN.1 types and codecs in Python programming
 language. It has been first written to support particular protocol (SNMP)
 but then generalized to be suitable for a wide range of protocols
 based on ASN.1 specification.
python3-pydoc - 3.8.5-2 - Python 3.8 pydoc module
python3-pyserial - 3.4-2 - This module encapsulates the access for the serial port. It provides backends
 for Python running on Windows, OSX, Linux, BSD (possibly any POSIX compliant
 system) and IronPython. The module named "serial" automatically selects the
 appropriate backend.
python3-qrcode - 6.1-3 - Pure python QR Code generator
python3-requests - 2.24.0-1 - Requests is the only Non-GMO HTTP library for Python, safe for human consumption
python3-rpyc - 5.0.1-3 - rpyc
python3-rsa - 4.6-1 - Is a pure-Python RSA implementation. It supports encryption and decryption,
 signing and verifying signatures, and key generation according to PKCS#1 version 1.5.
 It can be used as a Python library as well as on the commandline. 
python3-schedule - 0.6.0-2 - An in-process scheduler for periodic jobs that uses the builder pattern for configurati.
 The Schedule lets you run Python functions (or any other callable)
 periodically at predetermined intervals using a simple, human-friendly syntax.
python3-setuptools - 47.1.0-1 - Python 3.8 setuptools module
python3-six - 1.15.0-1 - Six is a Python 2 and 3 compatibility library.  It provides utility functions
 for smoothing over the differences between the Python versions with the goal of
 writing Python code that is compatible on both Python versions.  See the
 documentation for more information on what is provided.
python3-spidev - 3.5-2 - Bindings to the Linux input handling subsystem
python3-sqlite3 - 3.8.5-2 - Python 3.8 sqlite3 module
python3-unittest - 3.8.5-2 - Python 3.8 unittest module
python3-urllib - 3.8.5-2 - Python 3.8 URL library module
python3-urllib3 - 1.25.10-1 - HTTP library with thread-safe connection pooling, file post, and more.
python3-xml - 3.8.5-2 - Python 3.8 xml libs
rwcheck - 1-1 - rwcheck to check read and write by CRC, just data correctness but not performance.
sipeed_memtool - 0.0.1-1 - Sipeed tools memtool
sipeed_update_dtb - 0.0.1-1 - Sipeed tools update_dtb
spidev-test - 4.9.118-4.9.118 - SPI testing utility.
terminfo - 5.9-3 - Terminal Info Database (ncurses)
tinyalsa-lib - 1.1.1-34ffa583936aeb6938636c9c0a26a322b69b0d26 - TinyALSA is a small library to interface with ALSA i.
 It provides a basic pcm and mixer API, and avoids supporting complex and
 unnecessary operations, that could be dealt with at a higher level.
tinyalsa-utils - 1.1.1-34ffa583936aeb6938636c9c0a26a322b69b0d26 - This package contains utilities provided by TinyAL.
ubox - 2016-03-07-fd4bb41ee7ab136d25609c2a917beea5d52b723b - OpenWrt system helper toolbox
ubus - 2016-01-26-619f3a160de4f417226b69039538882787b3811c - OpenWrt RPC client utility
ubusd - 2016-01-26-619f3a160de4f417226b69039538882787b3811c - OpenWrt RPC daemon
uci - 2016-02-02.1-1 - Utility for the Unified Configuration Interface (UCI)
uclient-fetch - 2016-01-28-2e0918c7e0612449024caaaa8d44fb2d7a33f5f3 - Tiny wget replacement using libuclient
wget - 1.20.1-3 - Wget is a network utility to retrieve files from the Web using http
 and ftp, the two most widely used Internet protocols. It works
 non-interactively, so it will work in the background, after having
 logged off. The program supports recursive retrieval of web-authoring
 pages as well as ftp sites -- you can use wget to make mirrors of
 archives and home pages or to travel the Web like a WWW robot.
 This package is built with SSL support.
wpa-cli - 2017-11-08-2 - WPA Supplicant command line interface
wpa-supplicant - 2017-11-08-2 - WPA Supplicant
zlib - 1.2.8-1 - zlib is a lossless data-compression library.
 This package includes the shared library.
```
