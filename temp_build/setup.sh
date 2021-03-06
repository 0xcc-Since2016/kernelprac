#!/bin/bash 

source ./env.sh

## setup busybox env 
#  enter working directory 
cd $BUSYBOX_INSTALL
#  creating necessary directories
mkdir -p proc sys dev etc etc/init.d
touch etc/init.d/rcS
chmod +x etc/init.d/rcS 
touch etc/passwd
touch etc/group

#  write into init script
#  will execute at the time after booting up.
cat << ENDER > etc/init.d/rcS 
#!/bin/sh
# startup script...
mount -t proc none /proc
mount -t sysfs none /sys
mount -t debugfs none /sys/kernel/debug/
/sbin/mdev -s

#make tmp dir usable...
mkdir /tmp
chmod 777 -R /tmp
mkdir /home
mkdir -p /home/ctf 
adduser ctf

#insmods...
insmod /temp/softmmu

#mknod for example device for testing purpose...
chmod 0666 /dev/ptmx
cat /proc/modules 

su ctf
ENDER

#building file system.
find . | cpio -o --format=newc > ../temp_rootfs.img

