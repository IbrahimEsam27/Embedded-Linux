# Qt-Cpp
Qt is a versatile C++ framework known for its rich GUI elements and cross-platform capabilities. It excels in embedded Linux applications due to its efficiency, hardware acceleration support, and seamless integration. Supporting multiple languages like C++, Python, and JavaScript, Qt offers developers flexibility and ease of use.

## Setting up the environment 

1. Download the Poky build system (kirkstone branch)  
```bash
$ git clone -b kirkstone git://git.yoctoproject.org/poky
``` 
2. Download RPI BSP (kirkstone branch) 
```bash
$ git clone -b kirkstone https://github.com/agherzan/meta-raspberrypi.git 
``` 
3. Download openembedded (kirkstone branch)
```bash
$ git clone -b kirkstone https://github.com/openembedded/meta-openembedded.git
```
Note: for my steps, both poky, meta-raspberrypi and meta-openembedded repos are in the same path   
  
4. Source “oe-init-build-env” script 
```bash
$ source poky/oe-init-build-env 
```
1. Edit build/bblayers.conf and add layers to BBLAYERS variable  
```bash
BBLAYERS ?= " \
/ABSOLUTE/PATH/poky/meta \
/ABSOLUTE/PATH/poky/meta-poky \
/ABSOLUTE/PATH/poky/meta-yocto-bsp \
/ABSOLUTE/PATH/meta-raspberrypi \
/ABSOLUTE/PATH/meta-openembedded/meta-oe \
/ABSOLUTE/PATH/meta-openembedded/meta-python \
/ABSOLUTE/PATH/meta-openembedded/meta-networking \
/ABSOLUTE/PATH/meta-openembedded/meta-multimedia \
"
```  
1. Edit build/local.conf by changing ```MACHINE ??= "qemux86-64"``` to be ```MACHINE ?= "raspberrypi4-64"```  

2. Edit build/local.conf and add the following line  
```bash
DISTRO_FEATURES:append = " systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"
IMAGE_INSTALL += " packagegroup-core-boot"
```   
1. For developing you might need rootfs extra space, to add additional space as 5G edit build/local.conf and add the following line 
```bash
IMAGE_ROOTFS_EXTRA_SPACE = "5242880"
```

<a name="addingVNC"></a>
## Adding VNC server

Connect to your target through VNC server, then edit build/local.conf and add x11vnc to  IMAGE_INSTALL_append variable  
```bash
IMAGE_INSTALL:append = " x11vnc"
```  

<a name="addingQt"></a>
## Adding Qt 

1. Download the qt5 layer (kirkstone branch)  
```bash
$ git clone -b kirkstone https://github.com/meta-qt5/meta-qt5
``` 
2. Edit build/bblayers.conf and add the layer to BBLAYERS variable  
```bash
BBLAYERS ?= " \
....
/ABSOLUTE/PATH/meta-qt5 \
"
``` 
3.  To support Qt5 on image, edit build/local.conf and add
``` bash
IMAGE_INSTALL:append = " make cmake"
IMAGE_INSTALL:append = " qtbase-tools qtbase qtdeclarative qtimageformats qtmultimedia qtquickcontrols2 qtquickcontrols qtbase-plugins cinematicexperience liberation-fonts"
PACKAGECONFIG_FONTS_append_pn-qtbase = " fontconfig"
```  
4. To enable remote deployment on RPI using Qt platform, you need to add extra network configuration to build/local.conf  
```bash
IMAGE_INSTALL:append = " openssh-sftp-server rsync"
```  
## Baking and flashing the image 

1. Build the image using the build engine **BitBake**  
It may take many hours to finish the build process
```bash
$ bitbake core-image-sato -k
```  
 
1. If the build process was successful, the raspberry pi image will be under ```bashbuild/tmp/deploy/images/raspberrypi3-64/core-image-sato-raspberrypi3-64.rpi-sdimg```   

2. Flash the image on the SD card and make sure that it's formatted as free space  
my SD card is /dev/mmcblk0  
```bash
$ sudo dd if=tmp/deploy/images/raspberrypi4-64/core-image-sato-raspberrypi4-64.rpi-sdimg of=/dev/mmcblk0 status=progress conv=fsync bs=4M
```
4. After the image is ready, connect RPI with having the next interface 
```bash
$ x11vnc
```
then you open VNC viewer from your host and give it the IP of RPI and the port number that appear after executing ```x11vnc```
![](https://taotaodiy-yocto.readthedocs.io/en/latest/_images/runqemu003.png)

# Creating UI  

<a name="settingEnv"></a>
## Setting up environment

1. Install Qt5 Creator command line launcher, my Qt version is 15.5.2 from link [Qt.download](https://www.qt.io/download-qt-installer-oss) and choose linux
 - >Download the file, run and i choose version_15.5.2
2. Install Qt5 toolchain for cross compilation. The installation path may differ, just check your terminal output  
```bash
$ bitbake meta-toolchain-qt5  
$ cd tmp/deploy/sdk
$ ./poky-glibc-x86_64-meta-toolchain-qt5-aarch64-raspberrypi3-64-toolchain-3.0.2.sh 
```   

<a name="qtCreatorDeploy"></a>
## Configuring the cross compiling and remote deployment settings on Qt creator

1. First, you need to source the SDK toolchain. The source path may differ depending on the output of your SDK installation  
```bash
$ source /home/ibrahim/yocto/poky/build/target/environment-setup-cortexa72-poky-linux 
```  
2. From the same terminal launch qtcreator 
```bash
$ ~/Qt/Tools/QtCreator/bin/qtcreator 
```  
3. After Qt creator launches, you need to configure the device from **Tools -> External -> Configure**  
	1. Add new Generic Linux Device providing the name you want, the hostname/IP address of your device and the username   
	<p align="center">
  	<img  src="https://i.imgur.com/U5HwLPX.png">
	</p>
4. Then configure your Kits options from **Tools -> External -> Configure** 
	1. Create New Kit **(Raspberrypi4)**
    2. **Qt Versions** -> add the path of the SDK qmake  `/home/ibrahim/yocto/poky/build/target/sysroots/x86_64-pokysdk-linux/usr/bin/qmake` with any name  
		<p align="center">
  		<img  src="https://i.imgur.com/BMMMl8M.png">
		</p>
	3. **Compilers** -> add the path of C and C++ compilers `/home/ibrahim/yocto/poky/build/target/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gcc`  and the same for **``g++``**
     <p align="center">
  		<img  src="https://i.imgur.com/oNhyXP7.png">
		</p> 
		<p align="center">
  		<img  src="https://i.imgur.com/RL5xHXc.png">
		</p>  
    4. **Debuggers** -> add the remote debugger path
   
    `/home/ibrahim/yocto/poky/build/target/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gdb`   
		<p align="center">
  		<img  src="https://i.imgur.com/kIXAuul.png">
		</p>  
	5. **CMake** -> it might be auto detected, in case if not add the path 
   

   `
   /home/ibrahim/yocto/poky/build/target/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gcc
   `  

	<p align="center">
	<img  src="https://i.imgur.com/sZNYUnX.png">
	</p>  

#### You can Check my video Explaining Steps [LinkedIn-Video]()