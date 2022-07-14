# Для начала указываем исходный образ, он будет использован как основа
FROM php:7.4-fpm
# Необязательная строка с указанием автора образа
MAINTAINER PHPtoday.ru <info@phptoday.ru>

# RUN выполняет идущую за ней команду в контексте нашего образа.
# В данном случае мы установим некоторые зависимости и модули PHP.
# Для установки модулей используем команду docker-php-ext-install.
# На каждый RUN создается новый слой в образе, поэтому рекомендуется объединять команды.
#RUN apt-get update && apt-get install -y \
#        freetds-bin \
#        freetds-dev \
#        freetds-common \
#        curl \
#        wget \
#        git \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libmcrypt-dev \
#        libpng-dev \
#        libonig-dev \
#        libzip-dev \
#    && pecl install -o -f redis \
#    && rm -rf /tmp/pear \
#    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
#    && pecl install mcrypt-1.0.3 \
#    && docker-php-ext-enable mcrypt \
#    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/ \
#    && docker-php-ext-install -j$(nproc) iconv mbstring mysqli \
#    && docker-php-ext-configure mcrypt gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#    && docker-php-ext-install -j$(nproc) gd pdo_dblib pdo_mysql zip

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        curl \
        wget \
        git \
        libzip-dev \
        libonig-dev \
    && pecl install redis-5.1.1 \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mbstring mysqli pdo_mysql zip

#pdo_dblib    
# Куда же без composer'а.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Добавим свой php.ini, можем в нем определять свои значения конфига
ADD php.ini /usr/local/etc/php/conf.d/40-custom.ini

# Указываем рабочую директорию для PHP
WORKDIR /var/www

# Запускаем контейнер
# Из документации: The main purpose of a CMD is to provide defaults for an executing container. These defaults can include an executable, 
# or they can omit the executable, in which case you must specify an ENTRYPOINT instruction as well.
CMD ["php-fpm"]
