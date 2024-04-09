# Linux Kernel

The Linux kernel is the core component of the Linux operating system, responsible for managing system resources such as memory, processes, input/output (I/O), and device drivers. It is an open-source software project that was initially developed by Linus Torvalds in 1991 and is now maintained by a large community of developers around the world.

## Download Linux Kernel

### Vexpress (Qemu)

```bash
git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
cd linux

#configure the kernel to vexpress
make ARCH=arm vexpress_defconfig

# To indentify your kernel version 
make ARCH=arm kernelversion
```
# Linux Kernel

The Linux kernel is the core component of the Linux operating system, responsible for managing system resources such as memory, processes, input/output (I/O), and device drivers. It is an open-source software project that was initially developed by Linus Torvalds in 1991 and is now maintained by a large community of developers around the world.

## Download Linux Kernel

### Vexpress (Qemu)

```bash
git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
cd linux

#configure the kernel to vexpress
make ARCH=arm vexpress_defconfig

# To indentify your kernel version 
make ARCH=arm kernelversion
```
### Compiling modules and store them in rootfs

The compiled modules have a .ko suffix and are generated in the same directory as the source code, meaning that they are scattered all around the kernel source tree.

To install them into the staging area of your root filesystem (we will talk about root filesystems in the next chapter), provide the path using **INSTALL_MOD_PATH**:

```bash
make -j4 ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- INSTALL_MOD_PATH=$HOME/rootfs modules_install
```

Kernel modules are put into the directory /lib/modules/[kernel version], relative to the root of the filesystem.

## Boot from TFTP server

### Vexpress (Qemu)

Copy the zImage and dtb file to the **tftp server**

```bash
cp linux/arch/arm/boot/zImage /srv/tftp/
cp linux/arch/arm/boot/dts/*-ca9.dtb /srv/tftp/
```

Start Qemu to boot on U-boot

```bash
sudo qemu-system-arm -M vexpress-a9 -m 128M -nographic -kernel u-boot -sd sd.img -net tap,script=./qemu-ifup -net nic
```

Set the bootargs to

```bash
setenv bootargs console=ttyAMA0 
saveenv
```

load kernel image `zImage` and DTB `vexpress-v2p-ca9.dtb` from TFTP into RAM

```bash
tftp $kernel_addr_r zImage
tftp $fdt_addr_r vexpress-v2p-ca9.dtb
```

boot the kernel with its device tree

```bash
bootz $kernel_addr_r - $fdt_addr_r
