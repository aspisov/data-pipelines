
# YARN deployment


## Prerequisites
[Running Hadoop cluster](/01_hadoop/README.md)

## Scripts
#### Setup YARN & NGINX
1. Make scripts executable:
```shell
# hadoop@tmpl-jn
chmod +x yarn_setup.sh nginx_setup.sh
```
2. Run the scripts:
```shell
# hadoop@tmpl-jn
./yarn_setup.sh
./nginx_setup.sh
```


## Instructions

#### Setup YARN
1. Paste the content of [yarn-site.xml](./yarn-site.xml) and [mapred-site.xml](./mapred-site.xml) into the respective files.
```shell
# hadoop@tmpl-jn
vim hadoop-3.4.0/etc/hadoop/yarn-site.xml 
vim hadoop-3.4.0/etc/hadoop/mapred-site.xml
```
2. Now spread these configs to all the nodes.
```shell
# hadoop@tmpl-jn
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-nn:hadoop-3.4.0/etc/hadoop/yarn-site.xml
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-dn-00:hadoop-3.4.0/etc/hadoop/yarn-site.xml
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-dn-01:hadoop-3.4.0/etc/hadoop/yarn-site.xml

scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-nn:hadoop-3.4.0/etc/hadoop/mapred-site.xml
scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-dn-00:hadoop-3.4.0/etc/hadoop/mapred-site.xml
scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-dn-01:hadoop-3.4.0/etc/hadoop/mapred-site.xml
```
3. Now navigate to the namenode and start the YARN services and history server:
```shell
# hadoop@tmpl-nn
hadoop-3.4.0/sbin/start-yarn.sh
mapred --daemon start historyserver
```

5. Make sure that the services are running:
```shell
# hadoop@tmpl-nn
jps
```

#### Setup NGINX

1. New nginx servers by copying the content of [nn](./nn), [ya](./ya) and [dh](./dh) files:
```shell
# team@tmpl-jn
sudo vim /etc/nginx/sites-available/nn
sudo vim /etc/nginx/sites-available/ya
sudo vim /etc/nginx/sites-available/dh
sudo ln -s /etc/nginx/sites-available/nn /etc/nginx/sites-enabled/nn
sudo ln -s /etc/nginx/sites-available/ya /etc/nginx/sites-enabled/ya
sudo ln -s /etc/nginx/sites-available/dh /etc/nginx/sites-enabled/dh
sudo systemctl restart nginx
sudo systemctl status nginx
```

2. After that we need to create password for the these services. Run the following command and enter the password when prompted:
```shell
# team@tmpl-jn
sudo apt-get update
sudo apt-get install apache2-utils
sudo htpasswd -c /etc/.htpasswd admin
```

#### Accessing the services

1. Now go back to your local machine and create a tunnel to the these services:
```shell
# local machine
ssh -L 9870:127.0.0.1:9870 -L 8088:127.0.0.1:8088 -L 19888:127.0.0.1:19888 team@176.109.91.27
```

2. Once the SSH tunnel is established, open your browser and navigate to:

> http://localhost:9870<br>
> http://localhost:8088<br>
> http://localhost:19888<br>




