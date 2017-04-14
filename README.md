# Vagrant learn-ansible

iVagrant learn-oo-studio creates ready-to-go VM for [Ansible] (https://www.ansible.com/) evaluation/testing

The following is an overview of the ready-to-go VMs:

+ **master:** Ansible Master node with below component installed 
 + **Ansible** The core ansible.
 + **/root/inventory.yml** the inventory file for Ansible
 + **/root/ansible.cfg** 
 + **/root/test.yml** A sample playbook for adding ssh key on an ansible node

+ **node:** An node that will be managed by Ansible

## Requirements

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Tested on 5.0.20, but should also work on 5.0.20+ release.
- [Vagrant](http://www.vagrantup.com/downloads.html). Tested on 1.7.4
- Your workstation must have a direct internet connection (not via proxy - if your internet connection is behind a proxy, please check Virtualbox and Vagrant documentation to update Vagrantfile)

**master and node ** VM provisioned using [Ubuntu/trusty64] (https://atlas.hashicorp.com/ubuntu/boxes/trusty64) box from Atlas Hashicorp

## VMs details

VM | vCPU/vRAM | IP Address| user/password |  Administrator password |
---|---|---|---|---|
**master** | 2vCPU/1024 MB | 192.168.99.60 | vagrant | vagrant |
**node** | 2vCPU/1024 MB | 192.168.99.61 | vagrant | vagrant |

+ **Recommended hardware :** Computer with Multi-core CPU and 4GB+ memory


## Installation

#### Getting started:

Run the commands below:

	git clone https://github.com/gilleslabs/learn-ansible

#### Launching the whole environment:

1. Run the commands below:

	```
	cd learn-ansible
	vagrant up
	```

2. The setup will take some time to finish (approximatively 5 minutes depending on your hardware). Sit back and enjoy!

3. When the setup is done you will be able to connect to any of the VMs using your favorite ss client and credentials provided in [VMs details] (https://github.com/gilleslabs/learn-ansible#vms-details) 

4. To launch the playbook simply connect to **master** and run the commands below as **root user**:
	```
	cd /root
	ansible-playbook test.yml
	````

## MIT

Copyright (c) 2016 Gilles Tosi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
