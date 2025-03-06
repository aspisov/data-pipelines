#!/bin/bash
# initialize_hive.sh - Script to initialize Hive and start the Hive server

set -e  # Exit on error

HIVE_VERSION="4.0.0-alpha-2"
HIVE_HOME="/home/hadoop/apache-hive-${HIVE_VERSION}-bin"

echo "==============================================="
echo "Initializing and starting Apache Hive ${HIVE_VERSION}"
echo "==============================================="

# Check if environment variables are set, if not source from .profile
if [ -z "$HIVE_HOME" ]; then
    echo "HIVE_HOME not found in environment, sourcing from .profile..."
    source ~/.profile
fi

# Create HDFS directories for Hive
echo "Creating HDFS directories for Hive..."
hdfs dfs -mkdir -p /user/hive/warehouse
echo "Setting permissions for Hive directories..."
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse

# Initialize Hive schema
echo "Initializing Hive schema in PostgreSQL metastore..."
${HIVE_HOME}/bin/schematool -initSchema -dbType postgres
if [ $? -ne 0 ]; then
    echo "Failed to initialize Hive schema. Please check PostgreSQL connection and try again."
    exit 1
fi
echo "Hive schema initialized successfully."

# Start Hive server2
echo "Starting Hive Server2..."
hive --hiveconf hive.server2.enable.doAs=false \
     --hiveconf hive.security.authorization.enabled=false \
     --service hiveserver2 \
     1>> /tmp/hs2.log 2>> /tmp/hs2.log &

# Wait for HiveServer2 to start
echo "Waiting for HiveServer2 to start up..."
sleep 10

# Check if HiveServer2 is running
ps aux | grep -q "[H]iveServer2"
if [ $? -eq 0 ]; then
    echo "HiveServer2 is running."
    echo "Logs are available at: /tmp/hs2.log"
else
    echo "Warning: HiveServer2 may not have started properly. Check logs at /tmp/hs2.log"
fi

# Display connection information
echo ""
echo "==============================================="
echo "Hive initialization completed!"
echo "==============================================="
echo ""
echo "You can connect to Hive using the following command:"
echo "${HIVE_HOME}/bin/beeline -u jdbc:hive2://tmpl-jn:5433 -n scott -p tiger"
echo ""
echo "To check Hive server status:"
echo "ps aux | grep HiveServer2"
echo ""
echo "To view Hive server logs:"
echo "tail -f /tmp/hs2.log" 