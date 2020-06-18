FROM wordpress

RUN apt-get update &&\
    apt-get --assume-yes install software-properties-common &&\
    add-apt-repository ppa:certbot/certbot &&\
    apt-get --assume-yes install python-certbot-apache &&\
    rm -rf /var/lib/apt/lists/* &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php --install-dir=/bin --filename=composer &&\
    chmod +x /bin/composer
