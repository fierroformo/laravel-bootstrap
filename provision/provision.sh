#!/bin/bash
echo "Updating apt repositories..."
apt-get update


echo "Installing base packages..."
PACKAGES="build-essential zsh git vim-nox tree htop libjpeg-dev libfreetype6-dev graphviz"
PACKAGES="$PACKAGES gettext python nginx php5-fpm php5-cli php5-mcrypt php5-mysql"
PACKAGES="$PACKAGES debconf-utils"

apt-get install -y $PACKAGES


# Install and configure mysql
echo "Installing and configuring mysql..."
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"
apt-get install mysql-server -y > /dev/null


echo "Configuring server..."
php5enmod mcrypt
service php5-fpm restart


echo "Installing Oh My Zsh!..."
OHMYZSH_DIR=/home/vagrant/.oh-my-zsh

if [ ! -d $OHMYZSH_DIR ]; then
    sudo -Hu vagrant bash -c "git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH_DIR"
fi

cp /tmp/templates/zsh/zshrc /home/vagrant/.zshrc
cp /tmp/templates/zsh/zprofile /home/vagrant/.zprofile
chown vagrant:vagrant /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zprofile
chsh -s $(which zsh) vagrant

if [ ! -d $OHMYZSH_DIR ]; then
    sudo -Hu vagrant bash -c "git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH_DIR"
fi


echo "Creating virtual host..."
cp /tmp/templates/nginx/virtual-host /etc/nginx/sites-available/site
ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-available/default
service nginx restart


echo "Crating Swap file..."
fallocate -l 1G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile


echo "Installing composer and install laravel..."
PROJECT_DIR=/var/www/
cd $PROJECT_DIR
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
#composer create-project laravel/laravel . 4.1
#composer create-project laravel/laravel . 4.2
#composer create-project laravel/laravel . 5.0
composer create-project laravel/laravel . 5.1 # LTS VERSION
cp /tmp/templates/envs/.env $PROJECT_DIR


echo "Done."
