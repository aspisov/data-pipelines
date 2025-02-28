#!/bin/bash
# nginx_setup.sh

# Install required packages
sudo apt-get update
sudo apt-get install -y nginx apache2-utils

# Create Nginx configuration files
cat > /tmp/nn << EOF
server {
    listen 9870;
    server_name _;
    
    location / {
        auth_basic "Administrator's Area";
        auth_basic_user_file /etc/.htpasswd;
        proxy_pass http://tmpl-nn:9870;
    }
}
EOF

cat > /tmp/ya << EOF
server {
    listen 8088;
    server_name _;
    
    location / {
        auth_basic "Administrator's Area";
        auth_basic_user_file /etc/.htpasswd;
        proxy_pass http://tmpl-nn:8088;
    }
}
EOF

cat > /tmp/dh << EOF
server {
    listen 19888;
    server_name _;
    
    location / {
        auth_basic "Administrator's Area";
        auth_basic_user_file /etc/.htpasswd;
        proxy_pass http://tmpl-nn:19888;
    }
}
EOF

# Copy configuration files to Nginx
sudo cp /tmp/nn /etc/nginx/sites-available/
sudo cp /tmp/ya /etc/nginx/sites-available/
sudo cp /tmp/dh /etc/nginx/sites-available/

# Enable sites
sudo ln -sf /etc/nginx/sites-available/nn /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/ya /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/dh /etc/nginx/sites-enabled/

# Create password file (will prompt for password)
sudo htpasswd -c /etc/.htpasswd admin

# Restart Nginx
sudo systemctl restart nginx

echo "Nginx proxy setup completed!"