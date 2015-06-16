#!/bin/bash

php_config_file="/etc/php5/apache2/php.ini"


# Update the server
apt-get update
apt-get -y upgrade

if [[ -e /var/lock/vagrant-provision ]]; then
    exit;
fi

################################################################################
# Everything below this line should only need to be done once
# To re-run full provisioning, delete /var/lock/vagrant-provision and run
#
#    $ vagrant provision
#
# From the host machine
################################################################################

IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
sed -i "s/^${IPADDR}.*//" /etc/hosts
echo $IPADDR ubuntu.localhost >> /etc/hosts			# Just to quiet down some error messages

# Install basic tools
apt-get -y install build-essential binutils-doc git apache2


# Cleanup the default HTML file created by Apache
rm -rf /var/www/html

cd /var/www/
git clone http://stash.jon.tw:7990/scm/ps/jon.tw.git html

touch /var/lock/vagrant-provision
