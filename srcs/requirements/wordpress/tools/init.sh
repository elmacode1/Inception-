#!/bin/sh
set -eu

echo "Checking MariaDB connection..."
while ! mariadb-admin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB to wake up..."
    sleep 2
done

if ! command -v wp >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp.tmp
    chmod +x /usr/local/bin/wp.tmp
    mv /usr/local/bin/wp.tmp /usr/local/bin/wp
fi

if [ ! -f "wp-load.php" ]; then
    wp core download --force --allow-root
fi

if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbname="$MARIADB_DB" \
        --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" \
        --dbhost=mariadb \
        --allow-root
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="Inception Project" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_PASSWORD" \
        --admin_email="$WP_EMAIL" \
        --skip-email \
        --allow-root

    wp core is-installed --allow-root
    echo "WordPress setup complete."
else
    echo "WordPress is already installed."
fi

exec php-fpm8.2 -F
