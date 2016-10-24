!/usr/bin/env bash

chmod +x bootstrap.sh
# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTFOLDER='docker'

# create project folder
sudo mkdir "${PROJECTFOLDER}"
sudo mkdir "${PROJECTFOLDER}/wordpress1"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

#docker
echo 1--
curl -s https://get.docker.com | sudo sh
echo 2--
sudo apt-get -y install python-pip
echo 3--
sudo pip install docker-compose

#add docker to su group
sudo groupadd docker
sudo usermod -aG docker vagrant

#start docker
service docker start
docker run hello-world
