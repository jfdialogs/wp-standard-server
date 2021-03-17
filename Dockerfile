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
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')" &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" &&\
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then echo 'ERROR: Invalid installer checksum' && exit 1; fi &&\
    php composer-setup.php --quiet --install-dir=/bin --filename=composer &&\
    rm composer-setup.php &&\
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
