FROM php:7.4-apache

COPY docker/000-default.conf /etc/apache2/sites-available/

COPY docker/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container

# Enable Apache modules
RUN a2enmod rewrite


# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git



# Install PHP extensions
RUN docker-php-ext-install zip pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Copy existing application directory contents
# COPY . /var/www/html

# Create Laravel directories if they don't exist
RUN mkdir -p /var/www/html/storage/logs \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/bootstrap/cache

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html/


RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && usermod -aG www-data root

EXPOSE 80

ENTRYPOINT ["start-container"]

CMD ["apache2-foreground"]

