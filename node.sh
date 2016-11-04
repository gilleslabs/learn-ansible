#!/bin/sh
sudo useradd -m -d /home/gtosi/ gtosi
sudo -u gtosi echo 'gtosi:gtosi' | chpasswd
sudo -u gtosi mkdir -p /home/gtosi/.ssh/authorized_keys
sudo -u gtosi ssh-keygen -t rsa -f /home/gtosi/.ssh/gtosi -q -P ""
sudo -u gtosi cp /home/gtosi/.ssh/gtosi.pub /home/gtosi/.ssh/authorized_keys/.
sudo sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sudo service ssh restart
sudo apt-get install sshpass -y
