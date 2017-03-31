#!/bin/sh
#val
WORKDIR=$(cd $(dirname $0) && pwd)
THIS_FILE_NAME=${0##*/}
DOCUMENT_ROOT="/var/www/html"

# install apache2
sudo yum update -y
sudo yum install -y httpd
sudo apachectl enable
sudo apachectl start

# Distribute that conversion tool
cp -a $(ls $WORKDIR | grep -v $THIS_FILE_NAME) $DOCUMENT_ROOT

#####################################
# Apache security settings
#####################################
cat << _EOF_ > /etc/httpd/conf.d/security.conf
# Conceal version information
ServerTokens Prod
Header unset X-Powered-By
# Measures against httpoxy
RequestHeader unset Proxy
# Measures against click jacking
Header append X-Frame-Options SAMEORIGIN
# XSS measure
Header set X-XSS-Protection "1; mode=block"
Header set X-Content-Type-Options nosniff
# XST measure
TraceEnable Off

<Directory /var/www/html>
    # Enable .htaccess
    AllowOverride All
    # Prohibition of file list output
    Options -Indexes
</Directory>

_EOF_

cp -a /etc/httpd/conf.d/autoindex.conf /etc/httpd/conf.d/autoindex.conf.default
cat /dev/null > /etc/httpd/conf.d/autoindex.conf
cp -a /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.default
cat /dev/null > /etc/httpd/conf.d/welcome.conf

sudo apachectl restart

#####################################
# firewalld settings
#####################################
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-service=ssh --zone=public --permanent
sudo firewall-cmd --add-service=http --zone=public --permanent
sudo firewall-cmd --add-service=https --zone=public --permanent
sudo firewall-cmd --reload

#####################################
# disable SELinux
#####################################
setenforce 0
sed -i -e "/SELINUX=enforcing/c\SELINUX=disable" /etc/selinux/config
