import os               # Required for running command line functions
import board
import busio
import adafruit_ssd1306
import digitalio
import time
import neopixel

def kill_neopixels():
    led = digitalio.DigitalInOut(board.D15)
    led.direction = digitalio.Direction.OUTPUT
    led.value = True
    
    pixel_pin  = board.D12
    num_pixels = 16
    pixels = neopixel.NeoPixel(pixel_pin, num_pixels)
    ORDER = neopixel.GRB
    
    pixels = neopixel.NeoPixel(pixel_pin, num_pixels, brightness=0.05, auto_write=True, pixel_order=ORDER)
    
    pixels.fill((0, 0, 0))

def kill_display():
    i2c = busio.I2C(board.SCL, board.SDA)
    oled = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c, addr=0x3c)
    oled.fill(0)
    oled.show()
    
def main():
    #kill_neopixels() # Pixels should auto-shutdownn once the power mosfet is killed automatically
    kill_display()
    os.system("sudo shutdown now")
    
if __name__ == "__main__":
    main()
