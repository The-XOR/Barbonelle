

# Ora lanciare startx, aprire una finestra bash  e lanciare:
   gtk-theme-switch2 /usr/share/themes/Adwaita

   
# da qui in poi, la waifai non funzionera' piu. quindi.... OCIO!

# rendere la essedicard read only:
    - copiare install/cmdline.txt in /boot


    rm -rf /var/spool
    ln -s /tmp /var/spool

    sudo nano /etc/ssh/sshd_config ed aggiungere:
        UsePrivilegeSeparation no

    sudo nano  /usr/lib/tmpfiles.d/var.conf 
        replace "spool 0755" with "spool 1777"

    touch /tmp/dhcpcd.resolv.conf
    rm /etc/resolv.conf
    ln -s /tmp/dhcpcd.resolv.conf /etc/resolv.conf
        
    sudo nano /etc/fstab 
    - add "ro" to /boot 
    - add "ro" to /

    - add the lines:
        tmpfs /var/log tmpfs nodev,nosuid 0 0
        tmpfs /var/tmp tmpfs nodev,nosuid 0 0
        tmpfs /tmp     tmpfs nodev,nosuid 0 0
    reboot


######## per rimontare la sdcard in modalita' R/W:
    cd 
    sudo fw_dir/scripts/remount-rw.sh 
 
 