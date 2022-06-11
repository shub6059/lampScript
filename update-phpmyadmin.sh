#!/bin/bash
set -euo pipefail

# Use this script if the official package is no longer being updated
# https://askubuntu.com/questions/947805/how-to-upgrade-phpmyadmin-revisited
# https://docs.phpmyadmin.net/en/latest/setup.html#quick-install
# Note: You should install phpmyadmin with apt first

export DEBIAN_FRONTEND=noninteractive

PMA_VERSION=5.1.4
cd ~ || exit
echo -e "\e[96m phpmyadmin installation script  \e[39m"

echo -e "\e[96m Downloading phpmyadmin version $PMA_VERSION  \e[39m"
wget -c https://files.phpmyadmin.net/phpMyAdmin/$PMA_VERSION/phpMyAdmin-$PMA_VERSION-english.zip -O phpMyAdmin-$PMA_VERSION-english.zip

echo -e "\e[96m Extracting zip  \e[39m"
unzip -q -o phpMyAdmin-$PMA_VERSION-english.zip

echo -e "\e[96m Fix configs  \e[39m"
# https://stackoverflow.com/questions/34539132/updating-phpmyadmin-blowfish-secret-via-bash-shell-script-in-linux
randomBlowfishSecret=$(openssl rand -base64 32)
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" phpMyAdmin-$PMA_VERSION-english/config.sample.inc.php >phpMyAdmin-$PMA_VERSION-english/config.inc.php

echo -e "\e[96m Create missing folders  \e[39m"
sudo mkdir -p /usr/share/phpmyadmin/tmp
sudo mkdir -p /var/lib/phpmyadmin/tmp

echo -e "\e[96m Backup old installation  \e[39m"
sudo mv /usr/share/phpmyadmin /usr/share/phpmyadmin.bak

echo -e "\e[96m Move new installation  \e[39m"
sudo mv phpMyAdmin-$PMA_VERSION-english /usr/share/phpmyadmin

echo -e "\e[96m Fix tmp folder ownership  \e[39m"
sudo mkdir -p /usr/share/phpmyadmin/tmp
sudo mkdir -p /var/lib/phpmyadmin/tmp
# You might need to change group:user here
sudo chown -R www-data:www-data /usr/share/phpmyadmin/tmp
sudo chown -R www-data:www-data /var/lib/phpmyadmin/tmp

echo -e "\e[96m Cleanup  \e[39m"
sudo rm -rf /usr/share/phpmyadmin.bak
sudo rm -rf /usr/share/phpmyadmin/setup
sudo rm -r phpMyAdmin-$PMA_VERSION-english.zip

echo "Config file location is:"
echo "/usr/share/phpmyadmin/config.inc.php"

# sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

echo -e "\e[92m phpmyadmin version $PMA_VERSION installed  \e[39m"
