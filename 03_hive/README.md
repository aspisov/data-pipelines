# Hive deployment


## Prerequisites
[Running Hadoop cluster](/01_hadoop/README.md)<br>
[Running YARN](/02_yarn/README.md)

## Scripts

## Instructions

#### Setup PostgreSQL
1. Install PostgreSQL
```sh
# team@tmpl-nn
sudo apt install postgresql
```

2. Connect to PostgreSQL
```sh
# team@tmpl-nn
sudo -i -u postgres
```

3. Create a new database
```sh
# postgres@tmpl-nn
psql
CREATE DATABASE metastore;
CREATE USER hive WITH PASSWORD 'hiveMegaPass';
GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;
ALTER DATABASE metastore OWNER TO hive;
\q
```

4. Edit PostgreSQL configuration
```sh
# team@tmpl-nn
sudo vim /etc/postgresql/16/main/postgresql.conf
```
by adding this line:
```conf
listen_addresses = 'tmpl-nn'            # what IP address(es) to listen on;
```

5. Edit pg_hba.conf
```sh
# team@tmpl-nn
sudo vim /etc/postgresql/16/main/pg_hba.conf
```
by adding this lines:
```conf
host    metastore       hive            192.168.1.1/32          password
host    metastore       hive            192.168.1.102/32        password
```

6. Restart PostgreSQL
```sh
# team@tmpl-nn
sudo systemctl restart postgresql
sudo systemctl status postgresql
```

7. Install PostgreSQL client
```sh
# team@tmpl-jn
sudo apt install postgresql-client-16
```

8. Connect to PostgreSQL
```sh
# team@tmpl-nn
psql -h tmpl-nn -U hive -d metastore -p 5432 -W
\q
```
#### Setup Hive
1. Install Hive
```sh
# hadoop@tmpl-jn
wget https://archive.apache.org/dist/hive/hive-4.0.0-alpha-2/apache-hive-4.0.0-alpha-2-bin.tar.gz
```

2. Extract the archive
```sh
# hadoop@tmpl-jn
tar -xzvf apache-hive-4.0.0-alpha-2-bin.tar.gz
```

3. Install driver
```sh
# hadoop@tmpl-jn
cd apache-hive-4.0.0-alpha-2-bin/lib
wget https://jdbc.postgresql.org/download/postgresql-42.7.4.jar
```

4. Edit configs
```sh
# hadoop@tmpl-jn
vim apache-hive-4.0.0-alpha-2-bin/conf/hive-site.xml
```
by adding this lines:
```xml
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
```

5. Update profile
```sh
# hadoop@tmpl-jn
vim ~/.profile
```
by adding this lines:
```profile
export HIVE_HOME=/home/hadoop/apache-hive-4.0.0-alpha-2-bin
export HIVE_CONF_DIR=$HIVE_HOME/conf
export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib/*
export PATH=$PATH:$HIVE_HOME/bin
```

6. Source the `~/.profile`
```sh
# hadoop@tmpl-jn
source ~/.profile
```

#### Initialize Hive
1. Create a new directory in HDFS and set permissions
```sh
# hadoop@tmpl-jn
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
```

2. Initialize Hive
```sh
# hadoop@tmpl-jn
apache-hive-4.0.0-alpha-2-bin/bin/schematool -initSchema -dbType postgres
```

3. 
```sh
# hadoop@tmpl-jn
hive --hiveconf hive.server2.enable.doAs=false --hiveconf hive.security.authorization.enabled=false --service hiveserver2 1>> /tmp/hs2.log 2>> /tmp/hs2.log &
```

4. Connect to Hive
```sh
# hadoop@tmpl-jn
apache-hive-4.0.0-alpha-2-bin/bin/beeline -u jdbc:hive2://tmpl-jn:5433 -n scott -p tiger
```
