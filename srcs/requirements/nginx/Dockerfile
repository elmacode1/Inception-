FROM debian:bookworm 

RUN apt-get update && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -keyout /inception.key \
    -out /inception.crt \
    -subj "/CN=mael-gho.42.fr/" \
    -addext "subjectAltName=DNS:mael-gho.42.fr"

COPY conf/default /etc/nginx/sites-enabled/

CMD ["-g", "daemon off;"]

ENTRYPOINT ["nginx"]
