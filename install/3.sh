#!/bin/bash

clear
sudo chown music:music /sdcard
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y zip jwm xinit x11-utils x11-xserver-utils lxterminal pcmanfm adwaita-icon-theme gnome-themes-standard gtk-theme-switch conky libasound2-dev liblo-dev liblo-tools mpg123 dnsmasq hostapd
sudo apt-get install -y python3-pip git iptables dhcpcd5
sudo apt-get install -y puredata-core luarocks csound supercollider

python3 -m pip install Cython
python3 -m pip install cherrypy
python3 -m pip install pyliblo

sudo raspi-config nonint do_boot_behaviour B2

echo "#3 concluso"
echo "premere un tasto per riavviare"
read
reboot
