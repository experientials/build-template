# Das U-Boot

The brain is run on OpenWRT. U-Boot is the bootloader. We want to build the U-Boot used to ensure

- Transparency
- Security patches
- Support boot time programming
- Emulate Mass Storage Device over USB for Custom upgrades
- Embed a VM that can run scripts.


## Buildroot

[OpenWRT + U-Boot build system](https://openwrt.org/docs/guide-developer/build-system/start) are configured+compiled using Buildroot.
Does this mean that we would want to integrate a full Buildroot?


## Separate repository?

It may make more sense to create a separate repository to build a more generic OpenWRT + U-Boot


## WORM Log FS

The aim is to have the primary partition be a write once - read many logging file system that works by simply appending changes. It will be parsed at boot and construct the file tree structure in memory.

[Log-structured file system](https://en.wikipedia.org/wiki/Log-structured_file_system)

The bootloader must understand this file system and load the operating system from it.

Das U-Boot already understands [JFFS2](https://en.wikipedia.org/wiki/JFFS2) so the matter may potentially be resolved. It remains to review the current capability and identify future needs.

Should SquashFS play a role?


## Partition Structure

It is currently unclear what the exact partition map content is for the SD Cards written by LiveSuit for Allwinner. We need to get that under control.

[rikka0w0/licheepi_nano_squashed_rw_root.md](https://gist.github.com/rikka0w0/f56977f81d1228fc503b00ad7b526aa7)

Is the partition map something like this?:

```
Partition	Content		Offset		Size (byte)
mtd0		uboot-bin	0		0x58000 (360448)
		uboot-env	0x58000		0x8000
mtd1		dtb		0x60000		0x4000  (16kB)
mtd2		kernel		0x64000		0x400000 (4MB)
mtd3		rootfs		0x464000	0x4FC000 (4.98MB)
mtd4		overlay		0x960000	0x500000 (5MB)
```
