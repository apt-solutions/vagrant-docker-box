# vagrant-docker-box
A Vagrant box with docker preinstalled

uses https://github.com/William-Yeh/docker-enabled-vagrant as basebox with docker preinstalled

requires the following plugins

windows nfs compatibility
https://github.com/winnfsd/vagrant-winnfsd
`$ vagrant plugin install vagrant-winnfsd`

docker compose provisioner
https://github.com/leighmcculloch/vagrant-docker-compose
`vagrant plugin install vagrant-docker-compose`

run http://192.168.33.22:8080/containers/ for stats
