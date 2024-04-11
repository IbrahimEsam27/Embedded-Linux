# Using SSH to Connect to Vexpress Board on QEMU with Buildroot
This guide outlines the steps to use SSH on your host machine to connect to a Vexpress board running on QEMU with Buildroot.
## Step 1: Edit QEMU Start Script:
Navigate to the directory where QEMU images are located:
```bash
cd ~/buildroot-2024.02/output/images
```
Edit the `start-qemu.sh` script:
```bash
sudo vim start-qemu.sh
```
Modify the `qemu-system-arm` command to include necessary parameters for running the Vexpress board with appropriate options such as memory size, kernel image, device tree blob, root filesystem, networking, etc.

```bash
qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel zImage -dtb vexpress-v2p-ca9.dtb -drive file=rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" -net nic,model=lan9118 -net tap,script=/home/ibrahim/bootloader/qemu-ifup
```
## Step 2: Run QEMU:
Execute the modified `start-qemu.sh` script with sudo:
```bash
sudo ./start-qemu.sh
```
## Step 3: Set IP Address on Vexpress Board:
Once the kernel has started in QEMU, set the IP address of eth0 on the Vexpress board:
```bash
ip add a 192.168.0.100/24 dev eth0
```
## Step 4: Connect to Vexpress Board via SSH:
On the host terminal, use SSH to connect to the Vexpress board:

```bash
ssh root@192.168.0.100
```
## Successful SSH Connection
You have successfully connected to the Vexpress board running on QEMU with Buildroot using SSH.
## Notes:
- Ensure that the necessary networking configurations are correctly set up in the QEMU command and the networking script (`/home/ibrahim/bootloader/qemu-ifup`)
tftp_bash Script:
```bash
#!/bin/sh
ip a add 192.168.0.1/24 dev $1
ip link set $1 up
```

# Mounting RootFS Through NFS
This guide outlines the steps to mount the root filesystem through NFS.
### Step 1: Install NFS server:
```bash
sudo apt-get install nfs-kernel-server
```
---
### Step 2: Configure exports file (/etc/exports):
- Edit the `/etc/exports` file to specify the shared directory and access permissions.
- Add the following line:
```bash
/home/ibrahim/rootfs 192.168.0.100/24(rw,no_root_squash,no_subtree_check)
```
- `/home/ibrahim/rootfs`: Specifies the directory to be shared via NFS.
- `192.168.0.100`: Specifies the IP address of the NFS client with access permissions.
- `(rw,no_root_squash,no_subtree_check)`: Specifies the access permissions for the client.
- `rw`: Grants read/write access to the client.
- `no_root_squash`: Allows the root user on the client to access files as the root user on the server.
- `no_subtree_check`: Disables subtree checking for performance reasons.
---
### Step 3: Refresh exports:
Updates the NFS server's export table:
```bash
sudo exportfs -r
```
---
### Step 4: Configure U-Boot bootargs:
- Edit the U-Boot environment to specify boot arguments (`bootargs`) for the kernel.
- Set the following bootargs:
```bash
bootargs=console=ttyAMA0 root=/dev/nfs ip=192.168.0.100::::eth0 nfsroot=192.168.0.1:/home/ibrahim/rootfs,nfsvers=3,tcp rw init=/sbin/init
```
`bootargs` Explanation:

- **`bootargs=`**: Indicates that the following string is the boot arguments for the kernel.
- **`console=ttyAMA0`**: Sets the serial console for kernel messages to `ttyAMA0`.
- **`root=/dev/nfs`**: Specifies the root filesystem as an NFS mount.
- **`ip=192.168.0.100::::eth0`**: Sets the IP address and network interface for network communication.
- **`nfsroot=100.101.102.1:/home/eng-tera/rootfs`**: Specifies the NFS server and directory to be used as the root filesystem.
- **`nfsvers=3`**: Specifies that NFS version 3 should be used for the NFS mount.
- **`tcp`**: Specifies that TCP should be used as the transport protocol for NFS communication.
- **`rw`**: Specifies that the root filesystem should be mounted with read/write permissions.
- **`init=/sbin/init`**: Specifies the initial process (`init`) that the kernel should execute after the root filesystem is mounted.

# Initialize TFTP protocol
### Ubuntu
```bash
#Switch to root
sudo su
#Make sure you are connected to internet
ping google.com
#Download tftp protocol
sudo apt-get install tftpd-hpa
#Check the tftp ip address
ip addr `will be needed`
#Change the configuration of tftp
nano /etc/default/tftpd-hpa
	#write inside the file
    tftf_option = “--secure –-create”
#Restart the protocal
Systemctl restart tftpd-hpa
#Make sure the tftp protocol is running
Systemctl status tftpd-hpa
#Change the file owner
cd /srv
chown tftp:tftp tftp 
#Move your image or file to the server
cp [File name] /srv/tftp
```
### Create Virtual Ethernet For QEMU
This section for Qemu emulator users only **no need for who using HW**

Create a script `qemu-ifup` 
```bash
#!/bin/sh
ip a add 192.168.0.1/24 dev $1
ip link set $1 up
```
#### Start Qemu
In order to start Qemu with the new virtual ethernet
```bash
sudo qemu-system-arm -M vexpress-a9 -m 128M -nographic \
-kernel u-boot/u-boot \
-sd sd.img \
-net tap,script=./qemu-ifup -net nic
```
## Setup U-Boot IP address
```bash
#Apply ip address for embedded device
setenv ipaddr [chose] 
#Set the server ip address that we get from previous slide
setenv serverip [host ip address]

#### WARNING ####
#the ip address should has the same net mask
```
## Load File to RAM
First we need to know the ram address by running the following commend
```bash
# this commend will show all the board information and it start ram address
bdinfo
```
### Load from FAT
```bash
# addressRam is a variable knowen from bdinfo commend
fatload mmc 0:1 [addressRam] [fileName]
```
### Load from TFTP
```bash
# addressRam is a variable knowen from bdinfo commend
tftp [addressRam] [fileName]
```
