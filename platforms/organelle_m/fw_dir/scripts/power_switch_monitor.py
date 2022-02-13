import time
import RPi.GPIO as GPIO
import os
import importlib

fw_dir = os.getenv("FW_DIR")

GPIO.setmode(GPIO.BCM)

GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)

time.sleep(1)

while True:
        if not GPIO.input(0):
            os.system(fw_dir + "/scripts/shutdown.sh")
        time.sleep(1)

