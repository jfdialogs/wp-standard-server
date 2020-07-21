FROM wordpress:php7.3

RUN apt-get update &&\
    apt-get --assume-yes install gnupg varnish logrotate net-tools dnsutils wget nano zip unzip uuid-runtime software-properties-common git python-pip python-dev &&\
    add-apt-repository -r ppa:certbot/certbot &&\
    apt-get --assume-yes install python-certbot-apache &&\
    rm -rf /var/lib/apt/lists/* &&\
    pecl install redis &&\
    docker-php-ext-enable redis &&\
    curl https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - &&\
    curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
    apt-get update &&\
    apt-get install -y nodejs &&\
    npm install --global -g yarn &&\
#    npm -g i bower globally &&\
    npm install --global --save-dev webpack &&\
    npm install --global --save-dev webpack-cli &&\
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php --install-dir=/bin --filename=composer &&\
    chmod +x /bin/composer &&\
    php -v &&\
    python -V &&\
    apachectl -V &&\
    varnishd -V &&\
    echo "Certbot:$(apt-cache policy certbot | grep -i Installed)" &&\
    echo "NodeJS: $(node -v)" &&\
    echo "NPM: $(npm -v)" &&\
    echo "Yarn: $(yarn -V)" &&\
    echo "Webpack: $(webpack -v)" &&\
    php /bin/composer -V &&\
    echo ""

COPY --chown=www-data:www-data web /var/www/html
COPY --chown=www-data:www-data docker /docker

COPY --chown=root:root docker/etc/default/varnish /etc/default/varnish
COPY --chown=root:root docker/scripts/startup /startup

ENTRYPOINT /startup
