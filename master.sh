#!/bin/sh
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y
cat<< ANSIBLE | sudo tee -a /root/inventory.ini
[node]
192.168.99.61
ANSIBLE
sudo apt-get install sshpass -y
sudo ssh-keygen -t rsa -C "gtosi@soprasteria.com" -N "" -f /root/.ssh/id_rsa
sudo sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no root@192.168.99.61
sudo sshpass -p 'vagrant' scp 192.168.99.61:/home/gtosi/.ssh/gtosi.pub /root/.
cat<< CFG | sudo tee -a /root/ansible.cfg
[defaults]
hostfile = /root/inventory.ini
CFG
cat<< TEST | sudo tee -a /root/test.yml
---
- hosts: all
  tasks:
  - name: ensure nginx is installed
    authorized_key:
      user: gtosi
      exclusive: yes
      key: "{{ lookup('file', '/root/gtosi.pub') }}"
      path: '/home/gtosi/.ssh/authorized_keys/gtosi.pub'
TEST
