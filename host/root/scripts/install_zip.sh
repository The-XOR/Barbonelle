#!/bin/bash

#WORK IN PROGRESS - UNTESTED :) 

#in case the deploy scripts need these
export USER_DIR=${USER_DIR:="/usbdrive"}
export PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts

oscsend localhost 4001 /oled/setscreen i 1

oscsend localhost 4001 /enableauxsub i 1
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "installing"
oscsend localhost 4001 /oled/aux/line/2 s "$1"
oscsend localhost 4001 /oled/aux/line/5 s "do not interrupt!"

echo "installing : " $1 
cd $PATCH_DIR 

ZIPFILE=$1

echo "unzip : " $1 
oscsend localhost 4001 /oled/aux/line/4 s "unzipping"

unzip -o $ZIPFILE > /tmp/install_files.txt ; ec=$?;
if [ $ec -ne 0 ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "install FAILED"
    oscsend localhost 4001 /oled/aux/line/5 s "unable to unzip"
    oscsend localhost 4001 /enableauxsub i 0
    exit 128
fi


INSTALL_DIR=`cat /tmp/install_files.txt | head -2 | tail -1 | sed 's/.* \(.*\)\/.*/\1/'`
echo "installed dir : " $INSTALL_DIR

ec=0

if [ -f $INSTALL_DIR/manifest.txt ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "checking manifest"
    mv $INSTALL_DIR/manifest.txt /tmp
    find $INSTALL_DIR -type f -print0  | xargs -0 sha1sum > /tmp/manifest.new
    diff /tmp/manifest.txt /tmp/manifest.new; ec=$?; 
    if [ $ec -ne 0 ] 
    then
        oscsend localhost 4001 /oled/aux/line/4 s "install FAILED"
        oscsend localhost 4001 /oled/aux/line/5 s "files corrupt"
        oscsend localhost 4001 /enableauxsub i 0
        exit 129 
    fi 
fi

if [ -f $INSTALL_DIR/deploy.sh ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "running deploy"
    cd $INSTALL_DIR
    ./deploy.sh "$INSTALL_DIR" ; ec=$?
    if [ $ec -gt 127 ] 
    then
        oscsend localhost 4001 /enableauxsub i 0
        oscsend localhost 4001 /oled/aux/line/4 s "install FAILED"
        oscsend localhost 4001 /oled/aux/line/5 s "deploy failed"
        oscsend localhost 4001 /enableauxsub i 0
        exit $ec
    fi
fi

#success

#remove zip file
cd $PATCH_DIR
rm $ZIPFILE

oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Installation"
oscsend localhost 4001 /oled/aux/line/2 s "Successful"
oscsend localhost 4001 /oled/aux/line/3 s "Enjoy :)" 
case "$ec" in
    0)
        oscsend localhost 4001 /oled/aux/line/5 s "restarting mother" 
        sleep 1
        ~/scripts/restart-mother.sh
    ;;
    1)
        oscsend localhost 4001 /oled/aux/line/5 s "restarting mother" 
        sleep 1
        ~/scripts/restart-mother.sh
    ;;
    2)
        oscsend localhost 4001 /oled/aux/line/5 s "rebooting..."
        sleep 1
        ~/scripts/reboot.sh
    ;;
    3)
        oscsend localhost 4001 /oled/aux/line/5 s "shutting down..."
        sleep 1
        ~/scripts/shutdown.sh
    ;;
esac

#irrelevant we dont get here :) 
oscsend localhost 4001 /enableauxsub i 0
exit $ec

