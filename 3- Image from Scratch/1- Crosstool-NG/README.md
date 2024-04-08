# Crosstool-NG
Crosstool-NG facilitates cross-compilation toolchain generation for diverse architectures, streamlining software development for embedded systems. It simplifies the process of compiling kernels, building applications, and creating custom binary utilities tailored to specific hardware targets, enhancing efficiency in the Linux ecosystem.
## Steps 
In order to make an avr compiler customized you need to download crosstool-ng
 - By cloning it from the repo: [Croostool-NG[]([https://github.com/yourusername/yourrepository)](https://github.com/crosstool-ng/crosstool-ng.git)
 - after cloning the repo you MUST to checkout to the following commit: **25f6dae8**

| Command | Definition |
| ------ | ------ |
| ./bootstrap | to setup the environment |
| ./configure --enable-local | to check all dependencies |
| make | to generate a makefile for Crosstool-NG |
| ./ct-ng list-samples | to list all microcontrollers supported |
| ./ct-ng [Microcontroller] | to configure the Microcontroller used |
| ./ct-ng makemenuconfig | to configure the toolchain |
| ./ct-ng build | to build your toolchain |
##### You will face allot of libraries missing you need to get it by sudo apt install.
```
sudo apt install build-essential git autoconf bison flex texinfo help2man gawk \
libtool-bin libncurses5-dev unzip
```
##### _Once the build is complete you will notice x-tool file created on your home directory Under avr/bin you will see all binutil_
#### for arm-cortexa9_neon-linux-musleabihf:
###### You are required to customize an arm toolchain for your project.Make sure it support:
 - Musl library
 - Make
 - Strace
