
## Prerequisites
[Running Hadoop cluster](/01_hadoop/README.md)

## Hadoop user interface
1. Create a new nginx configuration file named `nn` inside `/etc/nginx/sites-available/` folder:
```bash
sudo vim /etc/nginx/sites-available/nn
```
Copy and paste the content of [nn](./nn) file.

2. Enable the Nginx site configuration and restart Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/nn /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```
3. After that we need to create password for the `nn` service. Run the following command:
```bash
sudo apt-get update
sudo apt-get install apache2-utils
sudo htpasswd -c /etc/.htpasswd admin
```
And enter the password when prompted.

4. Next we want to create a tunnel to the `nn` service. Run the following command from your local machine:
```bash
ssh -L 9870:127.0.0.1:9870 team@176.109.91.27
```

5. Once the SSH tunnel is established, open your browser and navigate to:

> http://localhost:9870

Use the following credentials:

> Username: admin<br>
> Password: \<your-password>
