# -*- mode: ruby -*-
# vi: set ft=ruby :
#!/bin/bash

#!/bin/bash

sudo apt update
sudo apt install -y nginx

sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
upstream backend {
    server 192.168.56.11;
    server 192.168.56.12;
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
    }
}
EOF

sudo systemctl enable nginx
sudo systemctl restart nginx

