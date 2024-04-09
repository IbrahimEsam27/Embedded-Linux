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
## Booting with initramfs
Copy uRamdisk you created earlier in this section to the boot partition on the microSD card, and then use it to boot to point that you get a U-Boot prompt. 
> Note: when running u-boot with qemu make sure that the memory argumunt you pass to command is suilable (512 or 1024 not 128)
```
qemu-system-arm -M vexpress-a9 -m 512M -nographic -kernel ~/bootloader/u-boot/u-boot -sd ~/bootloader/sd.img
```
Then enter these commands:
```bash
# make sure the variable initramfs doesn't overwrite the dtb and zimage variables
setenv initramfs [chose a value depends on bdinfo] ex: 0x61000000

fatload mmc 0:1 $kernel_addr_r zImage
fatload mmc 0:1 $fdt_addr_r am335x-boneblack.dtb
fatload mmc 0:1 $initramfs uRamdisk
setenv bootargs console=ttyO0,115200 rdinit=/bin/sh

bootz $kernel_addr_r $initramfs $fdt_addr_r
```
### After booting
 - you must mount dev , proc , sys
```
mount -t devtmpfs null /dev/
mount -t proc null /proc/
mount -t sysfs null /sys/
```
 - Now you will find your **`mmcblk0p2`** partition under **/dev**
 - create dirsectory to mount ***mmcblk0p2*** 
```
mkdir /media/rootfs
mount /dev/mmcblk0p2 /media/rootfs
switch_root /media/rootfs /sbin/init
```
Now you sould be on the Real Rootfs on SD Card **(mmcblk0p2)**

