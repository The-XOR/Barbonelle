#!/bin/bash

clear
raspi-config nonint do_vnc 1
sudo passwd -l root
sudo sed -i 's/^pi/music/g' /etc/sudoers.d/010_pi-nopasswd

git clone https://github.com/The-XOR/Barbonelle.git Organelle_OS --depth=1
cd /home/music/Organelle_OS/install
unzip wiringPi.zip
cd wiringPi
sudo ./build
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo systemctl disable hciuart.service
sudo systemctl disable vncserver-x11-serviced.service
sudo systemctl disable hostapd.service
sudo apt-get autoremove --purge
sudo mv /usr/share/icons/Adwaita/cursors/circle /usr/share/icons/Adwaita/cursors/circleORIG

cd /home/music/Organelle_OS/
sudo make barbonelle_deploy
cd /sdcard/
git clone https://github.com/critterandguitari/Organelle_Patches.git Patches --depth=1
rm -fr Patches/.git
rm -f Patches/.gitignore
rm -f Patches/README.md

sudo systemctl disable dnsmasq.service
sudo systemctl disable dhcpcd.service
sudo systemctl disable wpa_supplicant.service
sudo systemctl daemon-reload
