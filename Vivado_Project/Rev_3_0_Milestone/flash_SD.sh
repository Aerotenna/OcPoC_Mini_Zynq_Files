#!/bin/bash
function quit {
	echo Operation Complete
	exit
}



USER=ashirley
REPO=flight-control/trunk

#echo "This script does not check that the partitions are correct. If your second partition was not rootFS then you will need to run again"


#e2label /dev/sdb2 rootFs

# Copy Boot.bin && devicetree
cd /home/$USER/$REPO/OcPoC_Zynq_Mini/Rev_2_5_Milestone
cp BOOT.bin /media/$USER/BOOT
cp devicetree.dtb /media/$USER/BOOT
# Copy Uramdisk
cd /home/$USER/Documents/OcPoC_Mini_Zynq_Files
cp uramdisk.image.gz /media/$USER/BOOT
# Copy ubuntu FS
cp ubuntu* /media/$USER/rootFs
# Copy Linux Kernel Image
cd /home/$USER/$REPO/Kernel/linux-xlnx_15.4_w_i2c_working/arch/arm/boot
cp uImage /media/$USER/BOOT
#Switch over to card, expand ubuntu
cd /media/$USER/rootFs
tar xvf ubuntu-rootfs1.tar.gz
tar xvf ubuntu-rootfs2.tar.gz
# Clean up
rm ubuntu*
# Add libstdc++ to SD card
cp /usr/arm-linux-gnueabihf/lib/libstdc++.so.6.0.21 /media/$USER/rootFs/usr/lib/arm-linux-gnueabihf
cd /media/$USER/rootFs/usr/lib/arm-linux-gnueabihf
rm libstdc++.so.6
ln -s libstdc++.so.6.0.21 libstdc++.so.6

# Install the autopilots
cd /home/$USER/Documents/px4/build_posix_ocpoc_cross/src/firmware/posix
cp px4 arducopter /media/$USER/rootFs/root
cd /home/$USER/Documents/px4
cp -r ROMFS/ /media/$USER/rootFs/root
cp -r posix-configs/ /media/$USER/rootFs/root
cp -r test_data/ /media/$USER/rootFs/root
# Raise their execution
cd /media/$USER/rootFs/root
chmod +x px4
chmod +x arducopter


# Let's add the Built-in test'
mkdir BIT
cd /media/$USER/$REPO/OcPoC_Sensor/BIT
cp can_landing.awk can_landing_test sensors_test run.sh /media/$USER/rootFs/root/BIT


quit
