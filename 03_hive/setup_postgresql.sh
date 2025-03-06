#!/bin/bash
# setup_postgresql.sh - Script to set up PostgreSQL for Hive metastore

set -e  # Exit on error

echo "==============================================="
echo "Setting up PostgreSQL for Hive metastore"
echo "==============================================="

# Installation of PostgreSQL
echo "Installing PostgreSQL..."
sudo apt install -y postgresql

# PostgreSQL configurations
echo "Configuring PostgreSQL..."
PG_VERSION=$(psql --version | grep -oP '[0-9]+' | head -1)
PG_CONF_PATH="/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
PG_HBA_PATH="/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"

# Edit postgresql.conf to listen on the hostname
echo "Configuring postgresql.conf..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'tmpl-nn'/" $PG_CONF_PATH

# Edit pg_hba.conf to allow connections
echo "Configuring pg_hba.conf..."
if ! grep -q "host    metastore       hive            192.168.1.1/32" $PG_HBA_PATH; then
    echo "Adding host metastore configurations to pg_hba.conf..."
    sudo bash -c "cat >> $PG_HBA_PATH << EOF
host    metastore       hive            192.168.1.1/32          password
host    metastore       hive            192.168.1.102/32        password
EOF"
fi

# Restart PostgreSQL
echo "Restarting PostgreSQL service..."
sudo systemctl restart postgresql
sudo systemctl status postgresql

# Create database and user
echo "Creating Hive metastore database and user..."
sudo -i -u postgres psql << EOF
CREATE DATABASE metastore;
CREATE USER hive WITH PASSWORD 'hiveMegaPass';
GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;
ALTER DATABASE metastore OWNER TO hive;
EOF

echo "PostgreSQL setup completed successfully!"
echo "You can now proceed with Hive installation." 