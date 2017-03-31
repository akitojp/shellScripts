#!/bin/sh

# Install Package
sudo yum -y install epel-release
sudo yum -y install dnf
sudo yum -y update
sudo yum -y install vim
sudo yum -y install mlocate
sudo yum -y install unzip
sudo yum -y install git
sudo yum -y install tmux
sudo yum -y groupinstall base "Development tools"　

# Auto yum update
sudo yum install -y yum-cron
sudo sed -i -e "/^apply_updates/c\apply_updates = yes" /etc/yum/yum-cron.conf
systemctl enable yum-cron.service
systemctl start yum-cron.service

# shell Setting
sudo yum -y install zsh
sudo chsh -s /bin/zsh

# locale Setting
sudo localectl set-locale LANG=ja_JP.utf8
sudo localectl set-locale LANG=en_US.UTF-8
sudo timedatectl set-timezone Asia/Tokyo

# disable SELinux
setenforce 0
sed -i -e "/SELINUX=enforcing/c\SELINUX=disable" /etc/selinux/config
