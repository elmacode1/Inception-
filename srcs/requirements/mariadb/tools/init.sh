#!/bin/sh
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb_install_db --user=mysql --datadir=/var/lib/mysql
fi

mariadbd --user=mysql &

until mariadb-admin ping >/dev/null 2>&1; do
	echo "waiting for mariadbd ..."
	sleep 1
done

mariadb -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DB};"
mariadb -e "GRANT ALL ON ${MARIADB_DB}.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
mariadb -e "FLUSH PRIVILEGES;"

mariadb-admin shutdown

echo "Starting mariaDB:"
exec mariadbd --user=mysql
