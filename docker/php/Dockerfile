FROM php:8.2-fpm

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libpq-dev

# Installation des extensions PHP
RUN docker-php-ext-install \
    pdo_mysql \
    zip \
    intl \
    opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/app.ini

WORKDIR /var/www

# Optimisation pour la production
# RUN echo "opcache.preload=/var/www/config/preload.php" >> /usr/local/etc/php/conf.d/app.ini

RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www

USER www-data