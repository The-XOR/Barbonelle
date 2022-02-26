#!/bin/bash

clear
sudo cp ./config.txt /boot
sudo mkdir /root
sudo chmod +xr /root
sudo mkdir /sdcard
sudo chown music:music /sdcard
sudo mkdir /usbdrive
sudo chown music:music /usbdrive
sudo echo "/dev/mmcblk0p3 /sdcard  ext4 defaults,noatime 0 0" >> /etc/fstab

echo "#2 terminato."
echo "Premere un tasto per riavviare"
read
reboot
