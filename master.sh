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
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:brightbox/ruby-ng -y
sudo apt-get update -y
sudo apt-get install ruby2.3 -y
sudo gem install serverspec rake

sudo -u vagrant mkdir /home/vagrant/testing
cat<< PROPERTIES | sudo -u vagrant tee -a /home/vagrant/testing/properties.yml
192.168.99.60:
  :roles:
    - ansible
    - vagrant
  :server_id: 101
192.168.99.61:
  :roles:
    - vagrant
  :server_id: 102
PROPERTIES

sudo -u vagrant mkdir /home/vagrant/testing/spec
sudo -u vagrant mkdir /home/vagrant/testing/spec/ansible
sudo -u vagrant mkdir /home/vagrant/testing/spec/vagrant

cat<< COLOR | sudo -u vagrant tee -a /home/vagrant/testing/.rspec
--color
--format documentation
COLOR

cat<< RAKE | sudo -u vagrant tee -a /home/vagrant/testing/Rakefile
require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

properties = YAML.load_file('properties.yml')

desc "Run serverspec to all hosts"
task :spec => 'serverspec:all'

namespace :serverspec do
  task :all => properties.keys.map {|key| 'serverspec:' + key.split('.')[0] }
  properties.keys.each do |key|
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST'] = key
      t.pattern = 'spec/{' + properties[key][:roles].join(',') + '}/*_spec.rb'
      t.fail_on_error = false
    end
  end
end
RAKE

cat<< HELPER | sudo -u vagrant tee -a /home/vagrant/testing/spec/spec_helper.rb
require 'serverspec'
require 'net/ssh'
require 'yaml'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

HELPER

cat<< ANSIBLE | sudo -u vagrant tee -a /home/vagrant/testing/spec/ansible/sample_spec.rb
require 'spec_helper'


describe package('ansible'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('sshpass'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe file('/root/ansible.cfg') do
  it { should exist }
end

describe file('/root/test.yml') do
  it { should exist }
end

describe file('/root/inventory.ini') do
  it { should exist }
end
ANSIBLE

cat<< VAGRANT | sudo -u vagrant tee -a /home/vagrant/testing/spec/vagrant/sample_spec.rb
require 'spec_helper'

describe user('vagrant') do
  it { should exist }
end

VAGRANT

