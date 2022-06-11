#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 20.04 dev Server
# Run like (without sudo) - bash install_lamp.sh
# Script should auto terminate on errors

export DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m Adding PPA  \e[39m"
sudo add-apt-repository -y ppa:ondrej/apache2
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

echo -e "\e[96m Installing apache  \e[39m"
sudo apt-get -y install apache2

INSTALL_PHP_VER=${1:-8.1}

echo -e "\e[96m Installing php - ${INSTALL_PHP_VER} \e[39m"
sudo apt-get -y install "php${INSTALL_PHP_VER}-cli" "libapache2-mod-php${INSTALL_PHP_VER}"

sudo apt-get -y install curl zip unzip

echo -e "\e[96m Installing php extensions \e[39m"
if [ "$INSTALL_PHP_VER" = "7.4" ]; then
  sudo apt-get -y install php7.4-json php7.4-mysql php7.4-curl php7.4-ctype php7.4-uuid \
    php7.4-iconv php7.4-mbstring php7.4-gd php7.4-intl php7.4-xml \
    php7.4-zip php7.4-gettext php7.4-pgsql php7.4-bcmath php7.4-redis \
    php7.4-readline php7.4-soap php7.4-igbinary php7.4-msgpack \
    php7.4-sqlite3 
else
  sudo apt-get -y install php8.1-cli php8.1-curl php8.1-ctype php8.1-uuid \
    php8.1-pgsql php8.1-sqlite3 php8.1-gd \
    php8.1-imap php8.1-mysql php8.1-mbstring php8.1-iconv \
    php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap php8.1-gettext \
    php8.1-intl php8.1-readline \
    php8.1-msgpack php8.1-igbinary php8.1-ldap \
    php8.1-redis php8.1-grpc
fi

#sudo apt-get -y install php-xdebug
sudo phpenmod curl

# Enable some apache modules
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod "php${INSTALL_PHP_VER}"

echo -e "\e[96m Restart apache server to reflect changes  \e[39m"
sudo service apache2 restart

# Download and install composer
echo -e "\e[96m Installing composer \e[39m"
# Notice: Still using the good old way
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --force --filename=composer
# Add this line to your .bash_profile
# export PATH=~/.composer/vendor/bin:$PATH

echo -e "\e[96m Installing mysql client \e[39m"
sudo apt install -y mysql-client

# Check php version
php -v

# Check apache version
apachectl -v

# Check if php is working or not
php -r 'echo "\nYour PHP installation is working fine.\n";'

# Fix composer folder permissions
mkdir -p ~/.composer
sudo chown -R "$USER" "$HOME/.composer"

# Check composer version
composer --version

echo -e "\e[92m Open http://localhost/ to check if apache is working or not. \e[39m"

# Clean up cache
sudo apt-get clean
