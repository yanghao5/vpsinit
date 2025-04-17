#!/bin/bash

# 脚本开始时检查是否有 root 权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 root 权限运行此脚本"
  exit 1
fi

# install 
apt-get update && apt-get install wget curl neovim git btop ufw zsh rsync -y

#  add user hall
adduser --disabled-password --gecos "" hall
# 给 root 权限
usermod -aG sudo hall
echo "%sudo   ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

# set passwd
echo "root:op" | chpasswd
echo "hall:op" | chpasswd

# SHH
echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd

## hall ssh key
mkdir -p /home/hall/.ssh
cp /root/.ssh/authorized_keys /home/hall/.ssh
chown -R hall:hall /home/hall/.ssh
chmod 700 /home/hall/.ssh
chmod 600 /home/hall/.ssh/authorized_keys

# Docker
sh ./get-docker.sh

## 给 hall 用户执行 docker 权限
usermod -aG docker hall

# hall install files
#ohmyzsh
chmod +x ohmyzsh_install.sh
chown hall:hall ohmyzsh_install.sh
mv ohmyzsh_install.sh /home/hall

#nvm
chmod +x nvm_install.sh
chown hall:hall nvm_install.sh
mv nvm_install.sh /home/hall

# Cmake
chown hall:hall cmake-3.28.2-linux-x86_64.tar.gz
mv cmake-3.28.2-linux-x86_64.tar.gz /home/hall

# LLVM
chown hall:hall llvm.sh
mv llvm.sh /home/hall

# Golang
chown hall:hall go1.24.2.linux-amd64.tar.gz
mv go1.24.2.linux-amd64.tar.gz /home/hall
