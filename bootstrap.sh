!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTFOLDER='docker'

# create project folder
sudo mkdir "${PROJECTFOLDER}/wordpress1"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

#install docker
curl -s https://get.docker.com | sudo sh
sudo apt-get -y install python-pip
sudo pip install docker-compose

#add docker to su group
sudo usermod -aG docker vagrant

#start docker
service docker start

#start wordpress instance
cd ${PROJECTFOLDER}/wordpress1
docker-compose up -d
