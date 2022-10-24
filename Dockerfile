ARG PHP_VERSION=${PHP_VERSION:-8.0}
FROM php:${PHP_VERSION}-fpm-alpine AS php-system-setup

# Install system dependencies
RUN apk add --no-cache dcron busybox-suid libcap curl zip unzip git

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions intl bcmath gd pdo_mysql pdo_pgsql opcache redis uuid exif pcntl zip

# Install supervisord implementation
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

# Install caddy
COPY --from=caddy:2.2.1 /usr/bin/caddy /usr/local/bin/caddy
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

# Install composer
COPY --from=composer/composer:2 /usr/bin/composer /usr/local/bin/composer

FROM php-system-setup AS app-setup

# Set working directory
ENV APP_PATH=/srv/app
WORKDIR $APP_PATH

# Add non-root user: 'app'
ARG NON_ROOT_GROUP=${NON_ROOT_GROUP:-app}
ARG NON_ROOT_GROUP_ID=${NON_ROOT_GROUP_ID:-1000}
ARG NON_ROOT_USER=${NON_ROOT_USER:-app}
ARG NON_ROOT_USER_ID=${NON_ROOT_USER_ID:-1000}
RUN addgroup -S $NON_ROOT_GROUP -g $NON_ROOT_GROUP_ID  && adduser -S $NON_ROOT_USER -u $NON_ROOT_USER_ID -G $NON_ROOT_GROUP
RUN addgroup $NON_ROOT_USER wheel

# Set cron job
COPY ./config/crontab /etc/crontabs/$NON_ROOT_USER
RUN chmod 777 /usr/sbin/crond
RUN chown -R $NON_ROOT_USER:$NON_ROOT_GROUP /etc/crontabs/$NON_ROOT_USER && setcap cap_setgid=ep /usr/sbin/crond

# Switch to non-root 'app' user & install app dependencies
RUN chown -R $NON_ROOT_USER:$NON_ROOT_GROUP $APP_PATH
USER $NON_ROOT_USER

# Copy app
COPY --chown=$NON_ROOT_USER:$NON_ROOT_GROUP . $APP_PATH/
COPY ./config/php/local.ini /usr/local/etc/php/conf.d/local.ini

# Start app
EXPOSE 80
COPY ./entrypoint.sh /
COPY ./config/supervisor.conf /
COPY ./config/Caddyfile /

ENTRYPOINT ["sh", "/entrypoint.sh"]
