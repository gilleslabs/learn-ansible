# -*- mode: ruby -*-
# vi: set ft=ruby :

################################################################################################################
#                                                                                                              #
# Vagrantfile for provisioning ready-to-go Ansible VM.#
#                                                                                                              #
# Author: Gilles Tosi                                                                                          #
#                                                                                                              #
# The up-to-date version and associated dependencies/project documentation is available at:                    #
#                                                                                                              #
# https://github.com/gilleslabs/learn-ansible                                                                  #
#                                                                                                              #
################################################################################################################

Vagrant.configure(2) do |config|

	
	
	config.vm.define "node" do |node|
        node.vm.box = "ubuntu/trusty64"
		
			config.vm.provider "virtualbox" do |v|
				v.cpus = 2
				v.memory = 1024
			end
        node.vm.network "private_network", ip: "192.168.99.61"
		node.vm.provision :shell, path: "node.sh"
    end
	
	config.vm.define "master" do |master|
        master.vm.box = "ubuntu/trusty64"
		
			config.vm.provider "virtualbox" do |v|
				v.cpus = 2
				v.memory = 1024
			end
        master.vm.network "private_network", ip: "192.168.99.60"
		master.vm.provision :shell, path: "master.sh"
    end
end