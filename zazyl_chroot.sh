#!/bin/bash

echo "welcome to zazyl build"

echo "Hi , starting ... to build..."

echo -n "choose  1 to 8:"

read c

case $c in
   '1')
		mkdir  zazyl_chroot
		cd zazyl_chroot
		wget http://releases.linaro.org/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.bz2 > ~/zazy_chroot
		;;
	 '2')
		echo "Enter linaro into path"
		tar xvf  gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.bz2 
		export ARCH=arm
    		export  CROSS_COMPILE=~/zazyl_chroot/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415/bin/arm-linaro-gnueabihf-
 		export PATH=~/zazyl_chroot/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415/bin/:$PATH
      		;;
  	 '3')
		echo "Download the prerequeriments"
               	sudo apt-get install -y  build-essential qt-sdk bison flex automake autoconf git
		;;
	 '4')
               echo "create the structure of the chrooted system"
		mkdir -p  system/etc
		mkdir -p system/var
		mkdir -p system/opt
		mkdir -p system/home/
                mkdir -p system/bin
		mkdir -p system/xbin
                mkdir -p system/boot
		mkdir -p system/dev/
		mkdir -p  system/cdrom
    		mkdir -p system/proc
		mkdir -p system/media
		mkdir -p system/usr
		mkdir -p system/var
    		mkdir -p system/root
		mkdir -p system/run
		mkdir -p system/sbin
		mkdir -p system/selinux
		mkdir -p system/srv
		mkdir -p system/mnt
		mkdir -p system/sys
		mkdir -p system/lib
		mkdir -p system/tmp
		mkdir -p system/lost+found
                mkdir -p system/libx32
		mkdir -p system/lib32
		;;
	
	 '5')
  		echo "create the raw image"
		
		sudo dd if=/dev/zero of=~/zazyl_chroot/system.raw bs=4M
                sudo mkdir /media/zazyl_temp
		sudo mount -o ~/zazyl_chroot/ssytem.raw /media/zazyl_temp
		sudo cp  ~/zazyl_chroot/system/  /media/zazyl_temp
     		sync;sync;
		sudo umount /media/zazyl_temp
		sync;sync;
		;;
	
	 '6')
		echo "Download Linux pandaboard Kernel"
		
		git clone http://gitorious.org/omap-pm/linux > ~/zazyl_chroot
		
		cd linux
		./configure
		make  omap_defconfig
                make zImage uboot
                ;;

       	 '7')
		echo "Download lxde, Xorg,lightdm also other tools"
		
		git clone git://lxde.git.sourceforge.net/gitroot/lxde/ > ~/zazyl_chroot
		
		;;
	
	 '8')
		echo "copy kernel and  uboot  on system dir"
		
		sudo cp  ~/zazyl_chroot/linux/arch/arm/boot/zImage ~/zazyl_chroot/system/
		sudo cp ~/zazyl_chroot/linux/arch/arm/boot/uboot  ~/zazyl_chroot/system/
		
		;;
esac
			

echo "Thank you so much for compiling... Back to see you soon for new compilation"
