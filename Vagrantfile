# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'
Vagrant.require_version ">= 1.7.4"

########################
# Vagrant guest config #
########################
if !File.exist?('setup/config.yml')
    FileUtils.cp('setup/config.yml.sample', 'setup/config.yml')
end

require 'yaml'
boxes = YAML.load_file('setup/config.yml')

# set true to manage /etc/hosts in a multinode environment
manage_hosts = "true"

############################
# End Vagrant guest config #
############################

Vagrant.configure("2") do |config|
  boxes.each do |box|
    config.vm.define box["name"] do |node|
      node.vm.box = box["box"]
      node.vm.box_url = box["url"]
      node.vm.provider :virtualbox do |v, override|
        v.customize ["modifyvm", :id, "--memory", box["ram"]]
        v.customize ["modifyvm", :id, "--cpus", box["cpu"]]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", box["cpuexecutioncap"]]
        v.customize ["modifyvm", :id, "--chipset", "ich9"]
        v.customize ["modifyvm", :id, "--largepages", "on"]
        v.customize ["modifyvm", :id, "--vtxvpid", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
      end
      node.vm.network :private_network, ip: box["ip"]
      node.vm.hostname = box["name"]
      node.vm.provision "shell", path: "setup/ansible_bootstrap.sh"
      node.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "setup/playbook.yml"
        ansible.verbose  = true
        ansible.install  = false
        ansible.limit    = "all"
      end


      # Setup vm specific port forwards
      if box["fwd_guest_1"]
        node.vm.network "forwarded_port", guest: box["fwd_guest_1"], host: box["fwd_host_1"]
      end
      if box["fwd_guest_2"]
        node.vm.network "forwarded_port", guest: box["fwd_guest_2"], host: box["fwd_host_2"]
      end
    end

    # Configure /etc/hosts on each node
    if manage_hosts == 'true'
      config.vm.provision "shell", inline: "echo $1 $2 >> /etc/hosts", args: [box["ip"], box["name"]]
    end
  end
end
