#!/bin/bash
# yarn_setup.sh

HADOOP_VERSION="3.4.0"

# Create yarn-site.xml
cat > /tmp/yarn-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HDFS_HOME,HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>tmpl-nn</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address</name>
        <value>tmpl-nn:8032</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address</name>
        <value>tmpl-nn:8031</value>
    </property>
</configuration>
EOF

# Create mapred-site.xml
cat > /tmp/mapred-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>\$HADOOP_HOME/share/hadoop/mapreduce/*:\$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOF

# Distribute YARN configuration files to all nodes
for NODE in localhost tmpl-nn tmpl-dn-00 tmpl-dn-01; do
    if [ "$NODE" = "localhost" ]; then
        sudo -u hadoop bash -c "
            cp /tmp/yarn-site.xml /home/hadoop/hadoop-${HADOOP_VERSION}/etc/hadoop/
            cp /tmp/mapred-site.xml /home/hadoop/hadoop-${HADOOP_VERSION}/etc/hadoop/
        "
    else
        for FILE in yarn-site.xml mapred-site.xml; do
            scp /tmp/$FILE $NODE:/tmp/$FILE
            ssh $NODE "sudo -u hadoop cp /tmp/$FILE /home/hadoop/hadoop-${HADOOP_VERSION}/etc/hadoop/"
        done
    fi
done

# Format HDFS namenode and start services (run on namenode)
ssh tmpl-nn "sudo -i -u hadoop bash -c '
    ${HADOOP_VERSION}/sbin/start-yarn.sh
    mapred --daemon start historyserver
'"

echo "YARN setup completed!"