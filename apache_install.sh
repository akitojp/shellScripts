#!/bin/sh
#val
WORKDIR=$(cd $(dirname $0) && pwd)
THIS_FILE_NAME=${0##*/}
DOCUMENT_ROOT="/var/www/html"
UPLOAD_MAX_SIZE="4M"

# Initial
sudo yum install -y epel-release
sudo yum -y update

# install apache2
sudo yum install -y httpd
sudo apachectl enable
sudo apachectl start

# install php7
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd

# edit php.ini
cp -a /etc/php.ini /etc/php.ini.default
sed -i -e "/^upload_max_filesize/c\upload_max_filesize=$UPLOAD_MAX_SIZE" /etc/php.ini

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
    # Measures against pre-Apache 2.2
    <IfVersion < 2.3>
        # Conceal version information
        ServerSignature Off
        # Conceal of inode information of ETag
        FileETag MTime Size
    </IfVersion>
</Directory>

<Directory "/var/www/cgi-bin">
    <IfVersion < 2.3>
        ServerSignature Off
        FileETag MTime Size
    </IfVersion>
</Directory>
_EOF_

cp -a /etc/httpd/conf.d/autoindex.conf /etc/httpd/conf.d/autoindex.conf.default
cat /dev/null > /etc/httpd/conf.d/autoindex.conf
cp -a /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.default
cat /dev/null > /etc/httpd/conf.d/welcome.conf

#####################################
# firewalld settings
#####################################
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

#####################################
# other
#####################################
sudo apachectl restart
sudo systemctl restart network
