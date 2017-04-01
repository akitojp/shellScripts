#!/bin/sh
sudo yum install -y mariadb mariadb-server

sudo cp -p /usr/share/mysql/my-small.cnf /etc/my.cnf.d/server.cnf
sudo sed -i -e "/^\[client\]$/a default-character-set = utf8" /etc/my.cnf.d/server.cnf
sudo sed -i -e "/^\[mysqld\]$/a character-set-server=utf8" /etc/my.cnf.d/server.cnf

sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

# sudo mysql_secure_installation
# mysql -u root -p
# show databases;
# CREATE DATABASE test01_db DEFAULT CHARACTER SET utf8;
# USERNAMEユーザーを作成
# MariaDB [(none)]> CREATE USER 'USERNAME'@'localhost' IDENTIFIED BY 'password';
# テスト用のデータベース（test01_db）に権限があるユーザー（USERNAME）を設定
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON test01_db.* TO 'USERNAME'@'localhost' IDENTIFIED BY 'password';
