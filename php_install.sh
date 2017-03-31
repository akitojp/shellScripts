#!/bin/sh
# variable
WORKDIR=$(cd $(dirname $0) && pwd)
THIS_FILE_NAME=${0##*/}
UPLOAD_MAX_SIZE="4M"

# Initial
sudo yum install -y epel-release
sudo yum -y update

# install php7
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd

# edit php.ini
cp -a /etc/php.ini /etc/php.ini.default
sed -i -e "/^upload_max_filesize/c\upload_max_filesize=$UPLOAD_MAX_SIZE" /etc/php.ini
