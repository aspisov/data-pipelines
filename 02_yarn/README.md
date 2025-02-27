
# YARN deployment

## Disclaimer
Instead of team@176.109.91.27, you can use your own username and IP address.

## Prerequisites
[Running Hadoop cluster](/01_hadoop/README.md)

## Deploying YARN
1. Paste the content of [yarn-site.xml](./yarn-site.xml) and [mapred-site.xml](./mapred-site.xml) into the respective files.
```bash
vim hadoop-3.4.0/etc/hadoop/yarn-site.xml 
vim hadoop-3.4.0/etc/hadoop/mapred-site.xml
```
2. Now spread these configs to all the nodes.
```bash
# yarn-site.xml
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-nn:hadoop-3.4.0/etc/hadoop/yarn-site.xml
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-dn-00:hadoop-3.4.0/etc/hadoop/yarn-site.xml
scp hadoop-3.4.0/etc/hadoop/yarn-site.xml tmpl-dn-01:hadoop-3.4.0/etc/hadoop/yarn-site.xml

# mapred-site.xml
scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-nn:hadoop-3.4.0/etc/hadoop/mapred-site.xml
scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-dn-00:hadoop-3.4.0/etc/hadoop/mapred-site.xml
scp hadoop-3.4.0/etc/hadoop/mapred-site.xml tmpl-dn-01:hadoop-3.4.0/etc/hadoop/mapred-site.xml
```
3. Now navigate to the namenode and start the YARN services and history server:
```bash
ssh tmpl-nn
hadoop-3.4.0/sbin/start-yarn.sh
mapred --daemon start historyserver
```

5. Make sure that the services are running:
```bash
jps
```

## User interface

4. (from jump node sudo) New nginx servers by copying the content of [nn](./nn), [ya](./ya) and [dh](./dh) files:
```bash
sudo vim /etc/nginx/sites-available/nn
sudo vim /etc/nginx/sites-available/ya
sudo vim /etc/nginx/sites-available/dh
sudo ln -s /etc/nginx/sites-available/nn /etc/nginx/sites-enabled/nn
sudo ln -s /etc/nginx/sites-available/ya /etc/nginx/sites-enabled/ya
sudo ln -s /etc/nginx/sites-available/dh /etc/nginx/sites-enabled/dh
sudo systemctl restart nginx
sudo systemctl status nginx
```

5. After that we need to create password for the these services. Run the following command and enter the password when prompted:
```bash
sudo apt-get update
sudo apt-get install apache2-utils
sudo htpasswd -c /etc/.htpasswd admin
```

6. Now go back to your local machine and create a tunnel to the these services:
```bash
ssh -L 9870:127.0.0.1:9870 -L 8088:127.0.0.1:8088 -L 19888:127.0.0.1:19888 team@176.109.91.27
```

7. Once the SSH tunnel is established, open your browser and navigate to:

> http://localhost:9870<br>
> http://localhost:8088<br>
> http://localhost:19888<br>

Use the credentials from the previous step.



