#!/bin/bash

clear
raspi-config nonint do_boot_wait 0
raspi-config nonint do_ssh 1
raspi-config nonint do_i2c 1
raspi-config nonint do_wifi_country IT

echo "@music - rtprio 99" >> /etc/security/limits.conf
echo "@music - memlock unlimited" >> /etc/security/limits.conf
echo "@music - nice -10" >> /etc/security/limits.conf
echo "DefaultTimeoutStartSec=10s" >> /etc/systemd/system.conf
echo "DefaultTimeoutStopSec=5s" >> /etc/systemd/system.conf
timedatectl set-ntp false

echo "ora bisogna cambiare la password dell'utente"
echo "La password corrente e' raspberry -> cambiarla in music"
echo "Premere un taso per avviare raspi-config e cambiare la pw"
echo "System Options / password"
read
sudo raspi-config

echo "#1 concluso."
echo "Creare l'utente 'music' come da istruzioni"
read
exit
