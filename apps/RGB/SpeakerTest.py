import os
import time             # Required for delays
import board            # Required for I2C bus
import busio            # Required for I2C bus
import pyaudio          # Rewuired for I2S mic
import digitalio        # Required for I2C bus
import adafruit_ina219  # Required for voltage sensor
import adafruit_ssd1306 # Required for OLED displays

import sys              # Required for reading files and pipes
import fileinput        # Required for reading files and pipes
        
import numpy    as np
import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

from PIL import Image, ImageDraw, ImageFont


def get_input():
    if GPIO.input(8) == 0:  # UP
        time.sleep(.1)
        return "UP"
            
    if GPIO.input(25) == 0: # MID
        time.sleep(.1)
        return "SELECT"
            
    if GPIO.input(7) == 0:  # DOWN
        time.sleep(.1)
        return "DOWN"
    
    return "NONE"

def graph_array(draw, array):
    maxGraph = max(array)
    minGraph = min(array) if (min(array)!=max(array)) else min(array)-1
    
    for i in range(len(array)-1):
        value1 = 52 - (map_value(array[i]  , minGraph, maxGraph)/2)
        value2 = 52 - (map_value(array[i+1], minGraph, maxGraph)/2)

        #print(str(value1) + ' ' + str(value2))
        draw.line((i+2, value1, i+3, value2), width=0, fill=255) # Voltage Line

    return maxGraph, minGraph

def map_value(value, minimum, maximum):
    maxDif = abs(minimum-maximum) # distance between min and max
    curDif = abs(minimum-value)
    
    return curDif / maxDif * 100

def main(directory):
    #DISPLAY
    WIDTH   = 128
    HEIGHT  = 64

    volHist = [i for i in range(50)]# * 50
    
    i2c     = busio.I2C(board.SCL, board.SDA)
    oled    = adafruit_ssd1306.SSD1306_I2C(WIDTH, HEIGHT, i2c, addr=0x3c)
    image   = Image.new('1', (oled.width, oled.height))
    draw    = ImageDraw.Draw(image)
    
    oled.contrast(1) # Max contrast is 255

    GPIO.setup( 7, GPIO.IN, pull_up_down=GPIO.PUD_UP)  # DOWN       Order:
    GPIO.setup( 8, GPIO.IN, pull_up_down=GPIO.PUD_UP)  # UP      [U][C][D][O]
    GPIO.setup(25, GPIO.IN, pull_up_down=GPIO.PUD_UP)  # CENTER

    input = ""

    with fileinput.input() as lines:
        for line in lines:
            volHist.append(int(line[2:8]))
            volHist.pop(0)
            draw.rectangle((0, 0, oled.width, oled.height), outline=0, fill=0)
            graph_array(draw, volHist)
            oled.image(image)
            oled.show()
            #input = get_input()
    
if __name__ == "__main__":
    main('/opt/boobot/')
