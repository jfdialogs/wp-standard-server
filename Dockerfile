FROM wordpress:php7.3

RUN apt-get update &&\
    apt-get --assume-yes install dnsutils wget nano zip unzip software-properties-common &&\
    add-apt-repository ppa:certbot/certbot &&\
    apt-get --assume-yes install python-certbot-apache &&\
    rm -rf /var/lib/apt/lists/* &&\
    pecl install redis &&\
    docker-php-ext-enable redis &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php --install-dir=/bin --filename=composer &&\
    chmod +x /bin/composer
