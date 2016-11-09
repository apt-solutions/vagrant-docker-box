# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

#check for plugin Dependencies
unless Vagrant.has_plugin?("vagrant-docker-compose")
  system("vagrant plugin install vagrant-docker-compose")
  puts "Dependencies installed, please try the command again."
  exit
end
unless Vagrant.has_plugin?("vagrant-winnfsd")
  system("vagrant plugin install vagrant-winnfsd")
  puts "Dependencies installed, please try the command again."
  exit
end

Vagrant.configure("2") do |config|

  # VM settings
  config.vm.box = "williamyeh/ubuntu-trusty64-docker"
  config.vm.network "private_network", ip: "192.168.33.22"
  config.vm.synced_folder "docker/", "/home/vagrant/docker",type: "nfs"

  #Docker compose provision
  config.vm.provision :docker_compose, yml: "/vagrant/docker/wordpress1/docker-compose.yaml", rebuild: true, run: "always"

  #Virtualbox settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
end
