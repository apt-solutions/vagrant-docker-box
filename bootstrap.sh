!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTFOLDER='docker'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

#install docker
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update
apt-cache policy docker-engine

#install docker compose
sudo apt-get -y install python-pip
sudo pip install docker-compose

#add docker to su group
sudo groupadd docker
sudo usermod -aG docker vagrant

#start docker
sudo service docker start

#start wordpress instance
cd ${PROJECTFOLDER}/wordpress1
docker-compose up -d
