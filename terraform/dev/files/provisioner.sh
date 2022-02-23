#!/bin/sh

#Init admin user
sudo adduser --disabled-password --gecos '' "$SSH_USER"
sudo mkdir -p /home/"$SSH_USER"/.ssh
sudo touch /home/"$SSH_USER"/.ssh/authorized_keys
echo "$SSH_PUB_KEY" | sudo tee /home/"$SSH_USER"/.ssh/authorized_keys
sudo chmod 700 /home/"$SSH_USER"/.ssh
sudo chmod 600 /home/"$SSH_USER"/.ssh/authorized_keys
sudo chown -R "$SSH_USER:$SSH_USER" /home/"$SSH_USER"/.ssh
sudo usermod -aG sudo "$SSH_USER"
echo "$SSH_USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-"$SSH_USER"-for-password
