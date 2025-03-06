#!/bin/bash
# install_hive.sh - Script to install and configure Hive

set -e  # Exit on error

HIVE_VERSION="4.0.0-alpha-2"
POSTGRESQL_DRIVER_VERSION="42.7.4"
HIVE_HOME="/home/hadoop/apache-hive-${HIVE_VERSION}-bin"

echo "==============================================="
echo "Installing and configuring Apache Hive ${HIVE_VERSION}"
echo "==============================================="

# Install PostgreSQL client
echo "Installing PostgreSQL client..."
sudo apt install -y postgresql-client-16

# Download Hive
echo "Downloading Apache Hive ${HIVE_VERSION}..."
wget -q https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
if [ $? -ne 0 ]; then
    echo "Failed to download Hive. Please check the URL and try again."
    exit 1
fi

# Extract Hive
echo "Extracting Hive archive..."
tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz
rm apache-hive-${HIVE_VERSION}-bin.tar.gz  # Clean up

# Download PostgreSQL JDBC driver
echo "Downloading PostgreSQL JDBC driver..."
cd ${HIVE_HOME}/lib
wget -q https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_DRIVER_VERSION}.jar
if [ $? -ne 0 ]; then
    echo "Failed to download PostgreSQL JDBC driver. Please check the URL and try again."
    exit 1
fi
cd ~

# Create hive-site.xml
echo "Creating Hive configuration file..."
cat > ${HIVE_HOME}/conf/hive-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>hive.server2.authentication</name>
        <value>NONE</value>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
    </property>
    <property>
        <name>hive.server2.thrift.port</name>
        <value>5433</value>
        <description>TCP port to listen on, default 10000</description>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:postgresql://tmpl-nn:5432/metastore</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.postgresql.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>hive</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>hiveMegaPass</value>
    </property>
</configuration>
EOF

# Update .profile
echo "Updating environment variables in .profile..."
if ! grep -q "HIVE_HOME" ~/.profile; then
    cat >> ~/.profile << EOF

# Hive environment variables
export HIVE_HOME=${HIVE_HOME}
export HIVE_CONF_DIR=\$HIVE_HOME/conf
export HIVE_AUX_JARS_PATH=\$HIVE_HOME/lib/*
export PATH=\$PATH:\$HIVE_HOME/bin
EOF
    
    echo "Environment variables added to .profile"
    source ~/.profile
else
    echo "Hive environment variables already exist in .profile"
fi

echo "Hive installation completed successfully!"
echo "Please run 'source ~/.profile' to update your environment variables."
echo "You can now proceed with initializing Hive." 