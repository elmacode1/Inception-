FROM debian:bookworm 

RUN apt-get update && apt-get install -y php8.2-fpm php8.2-mysql \
    mariadb-client curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["init.sh"]
