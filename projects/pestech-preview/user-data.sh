#!/bin/bash
set -euo pipefail
exec > >(tee -a /var/log/pestech-bootstrap.log) 2>&1

dnf install -y nginx
systemctl enable --now amazon-ssm-agent

cat > /etc/nginx/nginx.conf <<'NGINX'
user nginx;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log warn;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    server_tokens off;

    gzip on;
    gzip_types text/css application/javascript application/json image/svg+xml;

    server {
        listen 80 default_server;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;


        add_header X-Content-Type-Options nosniff always;
        add_header X-Robots-Tag "noindex, nofollow, noarchive" always;

        location / {
            try_files $uri $uri/ =404;
        }

        location = /healthz {
            default_type text/plain;
            return 200 "ok\n";
        }

        location ~ /\. {
            deny all;
        }
    }
}
NGINX

printf '%s\n' 'Pestech preview server ready. Website files will be installed next.' \
  > /usr/share/nginx/html/index.html

nginx -t
systemctl enable --now nginx
