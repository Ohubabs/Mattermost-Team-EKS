#!/bin/bash
sudo adduser terra
sudo hostnamectl set-hostname terraform
sudo timedatectl set-timezone America/Los_Angeles
sudo echo "terra ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terra
sudo su - terra
sudo chown terra:terra -R /etc/ssh/sshd_config
sudo sed -i 's/no/yes/' /etc/ssh/sshd_config.d/*.conf
#sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
