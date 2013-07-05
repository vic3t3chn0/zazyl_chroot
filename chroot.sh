#!/bin/bash

function linaro(){
  		echo "Get linaro tool also build chroot"
              	        mkdir  -p zazyl_chroot/tools
                	cd zazyl_chroot && cd tools
               		wget http://releases.linaro.org/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.bz2
			cd ~/zazyl_chroot/tools
                	tar xvf  gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.bz2 
                	export ARCH=arm
                	export CROSS_COMPILE=~/zazyl_chroot/tools/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415/bin/arm-linux-gnueabihf-
               		export PATH=~/zazyl_chroot/tools/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415/bin/:$PATH
                }

function prerequirements(){
				 sudo apt-get install -y  build-essential qt-sdk bison flex automake autoconf git gcc-4.6 g++-4.6 *-4.6-multilib
}

function structure_build(){
			echo "Create the structure of the chrooted system"
			cd zazyl_chroot
			mkdir -p system/etc
			mkdir -p system/var
			mkdir -p system/opt
			mkdir -p system/home
	                mkdir -p system/bin
			mkdir -p system/xbin
	                mkdir -p system/boot
			mkdir -p system/dev/dhpcd
			mkdir -p system/dev/wifi
			mkdir -p system/dev/security
			mkdir -p system/dev/permissions
			mkdir -p system/lib/drm
			mkdir -p system/lib/egl
			mkdir -p system/lib/hw
			mkdir -p sysyem/lib/soundfx
			mkdir -p system/cdrom
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
	

}

function raw_create(){
							echo "create the raw image"
		
							sudo dd if=/dev/zero of=~/zazyl_chroot/system.raw bs=1024  count=0 seek=1024
                					sudo mkdir /media/zazyl_temp
}

function kernel_pandaboard(){
									echo "Download Linux pandaboard Kernel"
									
									cd  zazyl_chroot/tools
									git clone git://gitorious.org/omap-pm/linux.git
		
									cd linux
		
									make ARCH=arm CROSS_COMPILE=~/zazyl_chroot/tools/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux/bin/arm-linux-gnueabihf-   omap2plus_defconfig
                							make ARCH=arm CROSS_COMPILE=~/zazyl_chroot/tools/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux/bin/arm-linux-gnueabihf- zImage
									make ARCH=arm CROSS_COMPILE=~/zazyl_chroot/tools/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux/bin/arm-linux-gnueabihf- uImage
        		 }

echo "welcome to zazyl build"

echo "Hi , starting ... to build..."
			
	echo -n "choose  1 to 9:"

	echo "1 - Get linaro also build chroot"

	echo "2 - Download the prerequirements"

	echo "3 - Create the structure of the chrooted system"

	echo "4 - Create the raw image"

	echo "5 - Mount raw image system"

	echo "6 - Download the Pandaboard kernel"

	echo "7 - Download lxde, xorg also  other tools"

	echo "8 - Copy kernel and  uboot on system dir" 

	echo "9 - Create liveuser on system"


read c


case $c in
	 '1')  
		echo "Get linaro tool also build chroot"
		linaro()
		;;
	 '2')
		echo "Download the prerequeriments"
		prerequirements()
      		;;
  	 '3')
			structure_build()
			;;
	 '4')
		raw_create()
               	;;
	
	 '5')	
		echo "Mount raw image system"
		sudo mount -o ~/zazyl_chroot/system.raw /media/zazyl_temp
		sudo cp  ~/zazyl_chroot/system/  /media/zazyl_temp
     		sync;sync
		sudo umount /media/zazyl_temp
		sync;sync
		;;
	
	 '6')
		kernel_pandaboard()
		;;

       	 '7')
		echo "Download lxde, Xorg,lightdm also other tools"
		cd zazyl_chroot/tools
		git clone git://lxde.git.sourceforge.net/gitroot/lxde/lxde.git
		cd lxde
		./configure --prefix=~/zazyl_chroot --target=arm
		make
		make DESTDIR=~/zazy_chroot/system install
		cd ~
 		cd  zazyl_chroot/tools
		
		wget https://bitbucket.org/pypy/pypy/downloads/pypy-2.0.2-src.zip >  ~/zazyl_chroot
		unzip pypy-20.02-src.zip
		
		cd pypy/pypy/goal
		pypy ../../rpython/bin/rpython -Ojit targetpypystandalone           # get the JIT version
		pypy ../../rpython/bin/rpython -O2 targetpypystandalone             # get the no-jit version
		pypy ../../rpython/bin/rpython -O2 --sandbox targetpypystandalone   # get the sandbox version
		cd  ~
		cd ~/zazyl_chroot/tools
		
		wget http://prdownload.berlios.de/perlcross/perl-5.16.3-cross-0.7.4.tar.gz
		tar xvf perl-5.16.3-cross-0.7.4.tar.gz
		cd perl-5.16.3-cross-0.7.4
		./configure --prefix=~/zazyl_chroot --target=arm
		make
		make DESTDIR=~/zazyl_chroot/system  install
		;;
	
	 '8')
		echo "Copy kernel and  uboot  on system dir"
		
		sudo cp  ~/zazyl_chroot/linux/arch/arm/boot/zImage ~/zazyl_chroot/system/
		sudo cp ~/zazyl_chroot/linux/arch/arm/boot/uboot  ~/zazyl_chroot/system/
		
		;;
      	'9')
		echo "Create a liveuser on system"
		adduser liveuser -g  sudo 
		;;
esac

echo "Thank you so much for compiling... Back to see you soon for new compilation"
