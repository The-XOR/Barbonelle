#!/bin/bash

clear
echo "Cambiare password di root"
echo "Inserire [root] al prompt che appare"
sudo passwd root
sudo raspi-config nonint do_hostname barbonelle

echo "Step #0 concluso."
echo "Il raspoberro verra' riavviato - premere lo tasto"
read
reboot
