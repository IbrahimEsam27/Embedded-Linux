# Creating initramfs
`initramfs` (initial ramdisk filesystem) is a temporary, early root filesystem that is mounted before the real root filesystem becomes available during the Linux kernel's initialization process. It is commonly used in the boot process to perform tasks such as loading essential kernel modules, configuring devices, and preparing the system for the transition to the actual root filesystem.
## Sequence of instruction
An initial RAM filesystem, or initramfs, is a compressed cpio archive. cpio is an old Unix archive format, similar to TAR and ZIP but easier to decode and so requiring less code in the kernel. You need to configure your kernel with **CONFIG_BLK_DEV_INITRD** to support initramfs.
> Make sure do not includes kernel modules in the initramfs as it will take much space.
```bash
cd ~/rootfs
find . | cpio -H newc -ov --owner root:root > ../initramfs.cpio
cd ..
gzip initramfs.cpio
mkimage -A arm -O linux -T ramdisk -d initramfs.cpio.gz uRamdisk
```


