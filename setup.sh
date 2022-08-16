#!/bin/bash
echo "Starting setup..."
echo " "
echo "Creating file directories"
mkdir ./files
mkdir ./code/mic
read -p "apt-get update & upgrade? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Getting update and upgrade..."
    sudo apt-get -y update
    sudo apt-get -y upgrade
    echo " "
    echo "Update and Upgrade done "
fi
echo " "
read -p "Install Emacs? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing emacs..."
    sudo apt-get install emacs
    echo " "
    echo "Emacs installation done "
fi
echo " "
read -p "Install OLED Drivers? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing ...\n"
    echo " "
    mkdir ./files/OLED
    echo "Installing Adafruit_GPIO ...\n"
    echo " "
    sudo apt-get install python3-pip
    sudo pip3 install adafruit-circuitpython-ssd1306
    sudo apt-get install python3-pil
    sudo apt-get install python3-numpy
    sudo python3 -m pip install --force-reinstall adafruit-blinka
    echo "OLED driver installation done!"
fi
echo " "
read -p "Install NeoPixel Drivers? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo pip3 install adafruit-circuitpython-NeoPixel
    sudo pip3 install adafruit-circuitpython-Pixel-Framebuf
    sudo pip3 install adafruit-circuitpython-Pixelbuf
    sudo pip3 install rpi_ws281x adafruit-circuitpython-neopixel
    sudo cp ./code/snd-blacklist.conf /etc/modprobe.d/snd-blacklist.conf
    echo " "
    echo "Note snd_bcm2835 has been blacklisted! Tip from: https://github.com/jgarff/rpi_ws281x"
    echo " "
    echo "Neopixels driver installation done!"
fi
echo " "
read -p "Install INA219 Battery Sensor Drivers? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo pip3 install adafruit-circuitpython-ina219
    echo "INA219 driver installation done!"
fi
echo " "
read -p "Install MAX98357 I2S Speaker AMP? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash
    echo "INA219 driver installation done!"
fi
echo " "
read -p "Install SPH0645 I2S MIC? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo pip3 install --upgrade adafruit-python-shell
    wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2smic.py ./code/mic
    sudo python3 ./code/mic/i2smic.py
    echo "SPH0645 driver installation done!"
fi
echo " "
read -p "Install PCA9685 Servo Controller? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo pip3 install adafruit-circuitpython-pca9685
    sudo pip3 install adafruit-circuitpython-servokit
    echo "PCA9685 driver installation done!"
fi
echo " "
read -p "Install MPU9250 Accel/Gyro/Mag?(NOT WORKING) Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    #sudo pip install FaBo9Axis_MPU9250
    echo "MPU9250 driver installation done!"
fi
echo " "
read -p "Install BMP280 Pres/Temp Sensor? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo pip3 install adafruit-circuitpython-bme280
    echo "BME280 driver installation done!"
fi
echo " "
read -p "Install Hotspot? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Installing necessary drivers..."
    sudo apt-get -y install hostapd dnsmasq
    sudo mv ./code/misc/dhcpcd.conf /etc/dhcpcd.conf
    sudo mv ./code/misc/interfaces /etc/network/interfaces
    sudo mv ./code/misc/hostapd.conf /etc/hostapd/hostapd.conf
    sudo mv ./code/misc/hostapd /etc/default/hostapd
    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
    sudo mv ./code/misc/dnsmasq.conf /etc/dnsmasq.conf
    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
    echo "Hotspot installation done! (Reboot required to enable)"
fi
echo " "
read -p "Create Startup Script? Y/n... " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo " "
    echo "Setting up Script..."
    sudo cp ./code/rc.local /etc/rc.local
    sudo chmod +x /etc/rc.local
    echo "Script Ready! "
fi
echo " "
echo "DONE!"
