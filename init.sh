#!/bin/bash

sudo apt install -y git
sudo apt-get install zip

cd /home/pi
mkdir temp
cd temp
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
tar -xf Python-3.11.0.tgz
cd Python-3.11.0
./configure --enable-optimizations
make -j$(nproc)
make altinstall

#to ręcznie
#nano ~/.bashrc
# alias python3.11='/usr/local/bin/python3.11'
# alias python3='/usr/lib/rhasspy/usr/local/bin/python3'
#
echo "python3=/usr/local/bin/python3.11" >> ~/.bashrc
#echo "python3=/usr/lib/rhasspy/usr/local/bin/python3" >> ~/.bashrc

sudo apt-get install python3-pip

pip3 install onnxruntime==1.19.0 --break-system-packages
pip3 install numpy==1.26.4 --break-system-packages
pip3 install openwakeword=0.6.0 --break-system-packages
pip3 install paho-mqtt==1.6.1 --break-system-packages
pip3 install pyyaml==6.0 --break-system-packages
pip3 install -U tqdm scipy scikit-learn scipy matplotlib --break-system-packages

sudo cp -r /home/pi/.config/rhasspy/rhasspy-openWakeWord/models/ /home/pi/.local/lib/python3.11/site-packages/openwakeword/resources/

#sudo apt-get install supervisor
#cd /home/pi/temp
#wget https://github.com/rhasspy/rhasspy/releases/download/v2.5.11/rhasspy_arm64.deb
#dpkg-deb --extract rhasspy_arm64.deb tmp
#dpkg-deb --control rhasspy_arm64.deb tmp/DEBIAN
#sed -i 's/libgfortran4/libgfortran5/' ./tmp/DEBIAN/control
#dpkg --build tmp rhasspy_arm64.deb
#sudo dpkg -i ./rhasspy_arm64.deb
#
#wget https://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u2_arm64.deb
#sudo dpkg -i libssl1.1_1.1.1w-0+deb11u2_arm64.deb
#
#sudo chown pi: /home/pi/.config/rhasspy/profiles/pl/
#
#sudo mv /home/pi/rhasspy.service /etc/systemd/system/rhasspy.service
#sudo mv /home/pi/openwakeword.service /etc/systemd/system/openwakeword.service
#sudo systemctl enable rhasspy
#sudo systemctl enable openwakeword
#sudo systemctl daemon-reload
#sudo systemctl start rhasspy
#sudo systemctl start openwakeword
