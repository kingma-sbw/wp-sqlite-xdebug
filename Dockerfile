FROM wordpress:php8.4-apache

#LABEL org.opencontainers.image.authors="soulteary@gmail.com"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV WORDPRESS_PREPARE_DIR=/usr/src/wordpress

USER root

#RUN usermod -u 1000 www-data && \
#    groupmod -g 1000 www-data

# xdebug: https://xdebug.org/docs/install
ARG XDEBUG_VERSION=3.4.5
RUN pecl install xdebug-${XDEBUG_VERSION} && \
    docker-php-ext-enable xdebug

# plugin: https://github.com/WordPress/sqlite-database-integration
# details: https://soulteary.com/2024/04/21/wordpress-sqlite-docker-image-packaging-details.html
ARG SQLITE_DATABASE_INTEGRATION_VERSION=2.2.17
RUN set -eux; \
    src="sqlite-database-integration-${SQLITE_DATABASE_INTEGRATION_VERSION}"; \
    dest="${WORDPRESS_PREPARE_DIR}/wp-content/mu-plugins/sqlite-database-integration"; \
    curl -fsSL -o sqlite-database-integration.tar.gz \
        "https://github.com/WordPress/sqlite-database-integration/archive/refs/tags/v${SQLITE_DATABASE_INTEGRATION_VERSION}.tar.gz"; \
    tar zxf sqlite-database-integration.tar.gz; \
    mkdir -p "$dest"; \
    cp -r "$src"/* "$dest"/; \
    rm -rf "$src" sqlite-database-integration.tar.gz; \
    mv "$dest/db.copy" "${WORDPRESS_PREPARE_DIR}/wp-content/db.php"; \
    sed -i 's#{SQLITE_IMPLEMENTATION_FOLDER_PATH}#/var/www/html/wp-content/mu-plugins/sqlite-database-integration#' "${WORDPRESS_PREPARE_DIR}/wp-content/db.php"; \
    sed -i 's#{SQLITE_PLUGIN}#sqlite-database-integration/load.php#' "${WORDPRESS_PREPARE_DIR}/wp-content/db.php"; \
    mkdir "${WORDPRESS_PREPARE_DIR}/wp-content/database"; \
    touch "${WORDPRESS_PREPARE_DIR}/wp-content/database/.ht.sqlite"; \
    chmod 640 "${WORDPRESS_PREPARE_DIR}/wp-content/database/.ht.sqlite"

RUN chown -R www-data:www-data /var/www/html
