FROM alpine:latest

RUN apk update

RUN apk add vim

RUN apk add curl
RUN apk add openrc --no-cache

RUN apk add apache2

RUN apk add php php-intl php-openssl php-curl php-ldap php-pear php-common php-fpm php-mysqlnd php-pdo php-bcmath php-soap php-gd php-xml php-zip  php-apache2 php-pdo_mysql php-ctype php-json php-zlib php-dom php-session php-fileinfo  php-gettext php-imap  php-exif  php-imap  php-redis php-cli php-mbstring  php-mysqli php-simplexml php-xmlreader php-xmlwriter php-sodium php-phar php-tokenizer php-pgsql
COPY httpd.conf /etc/apache2/httpd.conf

WORKDIR /var/www/localhost/htdocs

COPY ./ /var/www/localhost/htdocs/./

RUN chown -R apache:apache /var/www/localhost/htdocs
 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN yes | composer update

RUN composer install --no-interaction

RUN php artisan cache:clear

RUN php artisan config:clear

RUN php artisan route:clear

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

EXPOSE 80