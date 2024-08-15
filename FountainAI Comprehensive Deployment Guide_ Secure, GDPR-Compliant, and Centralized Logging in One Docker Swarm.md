
# **FountainAI Comprehensive Deployment Guide: Secure, GDPR-Compliant, and Centralized Logging in One Docker Swarm**

## **1. Introduction**

This guide provides an extensive, step-by-step process for deploying FountainAI on Docker Swarm within Amazon Lightsail. The focus is on security, GDPR compliance, and centralized logging, all managed within a single Docker Swarm setup. This document will walk you through the entire process, including setting up infrastructure, securing SSH access with 2FA via PAM, initializing Docker Swarm, deploying and managing Vapor microservices, and implementing a centralized GDPR-compliant logging system. The use of a **Golden Key** ensures secure management of secrets across the infrastructure.

## **2. Infrastructure Overview**

### **Components Involved**

- **Docker Swarm**: Orchestrates the deployment and management of all FountainAI microservices, including the logging stack.
- **Vapor Microservices**: The core components of FountainAI that handle different aspects of storytelling management, including character, session, and action management.
- **GDPR-Compliant Logging Stack**: A centralized logging solution using an open-source, self-hosted stack (Elastic Stack or Fluentd with Loki), integrated directly within the Docker Swarm.
- **Golden Key**: A master key used for securely managing and encrypting secrets across the infrastructure.

## **3. Step 1: Setting Up the Infrastructure**

### **Step 1.1: Provision AWS Lightsail Instances**

1. **Access AWS Lightsail**: 
   - Log in to your AWS account and navigate to the Lightsail service.
   - Click "Create Instance" to start the process.

2. **Configure Instance**:
   - **Platform**: Choose "Linux/Unix."
   - **Blueprint**: Select "OS Only" and then "Ubuntu 20.04 LTS."
   - **Instance Plan**: Choose an instance size based on your needs. For instance, you might select a 2 GB RAM instance for manager nodes and a 1 GB RAM instance for worker nodes.
   - **Instance Name**: Name your instances according to their roles (e.g., `fountainai-manager`, `fountainai-worker1`).

3. **Repeat for Additional Instances**:
   - Create one instance for the Docker Swarm manager and additional instances for workers as needed. The number of workers depends on the anticipated load and redundancy requirements.

4. **Allocate Static IPs**:
   - After each instance is created, navigate to the "Networking" tab in Lightsail.
   - Assign a static IP to each instance to ensure their IP addresses remain constant. This is crucial for a stable Docker Swarm configuration.

5. **Create DNS Records (Optional)**:
   - If you have a domain name, configure DNS records with your domain registrar to point to the static IPs of your manager node(s). Typically, you would create an `A` record pointing `your-domain.com` to your manager node’s static IP.

### **Step 1.2: Set Up Networking and SSH Access**

1. **Generate SSH Key Pair (if not available)**:
   - On your local machine, generate an SSH key pair if you don’t already have one:
     ```bash
     ssh-keygen -t rsa -b 4096 -f ~/.ssh/lightsail_key
     ```
   - This will create a private key (`lightsail_key`) and a public key (`lightsail_key.pub`).

2. **Upload SSH Public Key to Lightsail Instances**:
   - Access the Lightsail console, select each instance, and go to the "Networking" tab.
   - Under "SSH Key Pairs," upload your public key (`lightsail_key.pub`). If the Lightsail web interface does not support direct upload, log into each instance using the default SSH key provided by AWS and manually copy your SSH key.

3. **Log into Each Instance**:
   - Open a terminal and SSH into each instance using the newly generated SSH key:
     ```bash
     ssh -i ~/.ssh/lightsail_key ubuntu@<static-ip>
     ```

4. **Create a Non-Root User**:
   - After logging in, create a new non-root user for administrative tasks:
     ```bash
     sudo adduser fountainadmin
     sudo usermod -aG sudo fountainadmin
     ```
   - Follow the prompts to set the password and other user details.

5. **Copy SSH Key to New User**:
   - Copy your SSH public key to the new user’s SSH configuration:
     ```bash
     sudo mkdir /home/fountainadmin/.ssh
     sudo cp ~/.ssh/authorized_keys /home/fountainadmin/.ssh/
     sudo chown -R fountainadmin:fountainadmin /home/fountainadmin/.ssh
     ```
   - Ensure the permissions are correct to avoid SSH login issues:
     ```bash
     sudo chmod 700 /home/fountainadmin/.ssh
     sudo chmod 600 /home/fountainadmin/.ssh/authorized_keys
     ```

6. **Test SSH Login as New User**:
   - Log out and log back in as the new user using your SSH key:
     ```bash
     ssh -i ~/.ssh/lightsail_key -p 2222 fountainadmin@<static-ip>
     ```

### **Step 1.3: Secure SSH with 2FA via PAM**

1. **Install Google Authenticator**:
   - On each instance, install the Google Authenticator PAM module:
     ```bash
     sudo apt-get update
     sudo apt-get install libpam-google-authenticator -y
     ```

2. **Configure Google Authenticator for the User**:
   - Switch to the non-root user:
     ```bash
     su - fountainadmin
     ```
   - Run the Google Authenticator setup:
     ```bash
     google-authenticator
     ```
   - Follow the prompts to set up 2FA (scan the QR code with your app):
     - Save emergency scratch codes somewhere safe.
     - Allow time-based tokens, disallow multiple uses of the same token, and enable rate-limiting.

3. **Configure PAM for SSH**:
   - Edit the PAM configuration file for SSH:
     ```bash
     sudo nano /etc/pam.d/sshd
     ```
   - Add this line at the top:
     ```bash
     auth required pam_google_authenticator.so
     ```

4. **Configure SSH Daemon**:
   - Edit the SSH configuration file:
     ```bash
     sudo nano /etc/ssh/sshd_config
     ```
   - Modify the following settings:
     ```bash
     Port 2222  # Change to a non-standard port
     PasswordAuthentication no
     ChallengeResponseAuthentication yes
     AuthenticationMethods publickey,keyboard-interactive
     PermitRootLogin no
     ```
   - Restart the SSH service to apply the changes:
     ```bash
     sudo systemctl restart sshd
     ```

5. **Test SSH with 2FA**:
   - Disconnect and reconnect using the non-root user:
     ```bash
     ssh -i ~/.ssh/lightsail_key -p 2222 fountainadmin@<static-ip>
     ```
   - After entering your SSH key, you should be prompted for the 2FA code.

### **Step 1.4: Secure the Firewall**

1. **Install and Configure UFW (Uncomplicated Firewall)**:
   - Install UFW on each instance:
     ```bash
     sudo apt-get install ufw -y
     ```
   - Configure UFW to allow SSH on the custom port and HTTPS:
     ```bash
     sudo ufw allow 2222/tcp
     sudo ufw allow 443/tcp
     sudo ufw enable
     sudo ufw default deny incoming
     ```

## **4. Step 2: Initialize Docker Swarm**

### **Step 2.1: Docker Swarm Setup**

1. **Initialize Swarm**:
   - On the manager node, initialize Docker Swarm:
     ```bash
     sudo docker swarm init --advertise-addr <manager-ip>
     ```
   - This command initializes the manager node and prepares it to orchestrate the Swarm. The `--advertise-addr` flag ensures that other nodes can join the Swarm by referencing this IP address.

2. **Join Worker Nodes**:
   - On each worker node, join the Swarm using the token provided by the manager node:
     ```bash
     sudo docker swarm join --token <swarm-join-token> <manager-ip>:2377
     ```
   - The `swarm-join-token` is obtained from the output of the `docker swarm init` command or by running:
     ```bash
     sudo docker swarm join-token worker
     ```

### **Step 2.2: Implement the Golden Key for Secure Bootstrapping**

1. **Generate and Secure the Golden Key**:
   - On the manager node, generate a strong Golden Key using `openssl`:
     ```bash
     openssl rand -base64 32 > /home/fountainadmin/golden.key
     ```
   - This Golden Key will be used to encrypt and decrypt all other secrets within the infrastructure.

2. **Secure the Golden Key**:
   - Ensure the Golden Key is securely stored and only accessible by the intended user:
     ```bash
     sudo chown root:root /home/fountainadmin/golden.key
     sudo chmod 600 /home/fountainadmin/golden.key
     ```
   - Optionally, store a backup of the Golden Key in a secure, offline location.

3. **Encrypt Sensitive Data with the Golden Key**:
   - Use the Golden Key to encrypt sensitive information such as database passwords, API keys,

 and certificates:
     ```bash
     openssl enc -aes-256-cbc -salt -in db_password.txt -out db_password.enc -pass file:/home/fountainadmin/golden.key
     ```
   - Store the encrypted files in a secure directory:
     ```bash
     sudo mv db_password.enc /etc/docker/secrets/
     ```

4. **Create Docker Secrets**:
   - Use Docker secrets to store encrypted files within the Swarm:
     ```bash
     sudo docker secret create db_password /etc/docker/secrets/db_password.enc
     ```

5. **Deploy Services with Secrets**:
   - When defining services in your `docker-compose.yml`, reference the Docker secrets:
     ```yaml
     services:
       database:
         image: postgres:latest
         environment:
           POSTGRES_PASSWORD_FILE: /run/secrets/db_password
         secrets:
           - db_password
     ```

## **5. Step 3: Implementing GDPR-Compliant Centralized Logging within the Swarm**

### **Step 3.1: Set Up the Logging Stack within Docker Swarm**

#### **Option 1: ELK Stack (Elastic Stack)**

1. **Deploy ELK Stack as Docker Services**:
   - Define Elasticsearch, Logstash, and Kibana as services within your Docker Swarm in the `docker-compose.yml` file:
     ```yaml
     version: '3.7'
     services:
       elasticsearch:
         image: docker.elastic.co/elasticsearch/elasticsearch:7.10.0
         environment:
           - discovery.type=single-node
           - xpack.security.enabled=true
           - bootstrap.memory_lock=true
           - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
         volumes:
           - es_data:/usr/share/elasticsearch/data
         networks:
           - lognet
         deploy:
           resources:
             limits:
               memory: 2g

       logstash:
         image: docker.elastic.co/logstash/logstash:7.10.0
         networks:
           - lognet
         volumes:
           - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
         deploy:
           resources:
             limits:
               memory: 1g

       kibana:
         image: docker.elastic.co/kibana/kibana:7.10.0
         environment:
           - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
         networks:
           - lognet
         deploy:
           resources:
             limits:
               memory: 512m

     volumes:
       es_data:

     networks:
       lognet:
         driver: overlay
     ```

2. **Configure Logstash for Data Anonymization**:
   - Configure Logstash to filter and anonymize sensitive data before it is sent to Elasticsearch. For example, anonymize IP addresses:
     ```ruby
     filter {
       mutate {
         gsub => [
           "message", "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", "XXX.XXX.XXX.XXX"  # Anonymize IP addresses
         ]
       }
     }
     ```

3. **Enable SSL/TLS Encryption**:
   - Ensure all communications between Elasticsearch, Logstash, and Kibana are encrypted using SSL/TLS. Configure certificates for each component.

4. **Implement Role-Based Access Control (RBAC)**:
   - Use Elasticsearch’s built-in security features to create roles and users. Define which users can access, modify, or delete logs.

5. **Set Up Data Retention Policies**:
   - Implement Index Lifecycle Management (ILM) in Elasticsearch to automatically delete logs after a specific retention period, such as 30 days, to comply with GDPR.

#### **Option 2: Fluentd with Loki**

1. **Deploy Fluentd and Loki as Docker Services**:
   - Define Fluentd and Loki as services within your Docker Swarm in the `docker-compose.yml` file:
     ```yaml
     version: '3.7'
     services:
       loki:
         image: grafana/loki:2.0.0
         ports:
           - "3100:3100"
         networks:
           - lognet
         deploy:
           resources:
             limits:
               memory: 1g

       fluentd:
         image: fluent/fluentd:latest
         networks:
           - lognet
         volumes:
           - ./fluent.conf:/fluentd/etc/fluent.conf
         deploy:
           resources:
             limits:
               memory: 512m

       grafana:
         image: grafana/grafana:latest
         ports:
           - "3000:3000"
         networks:
           - lognet
         deploy:
           resources:
             limits:
               memory: 512m

     networks:
       lognet:
         driver: overlay
     ```

2. **Configure Fluentd for GDPR Compliance**:
   - Use Fluentd’s filters to anonymize data before sending it to Loki:
     ```apache
     <filter **>
       @type anonymizer
       <record>
         user_id xxx-xxx-xxxx
         ip_address xxx.xxx.xxx.xxx
       </record>
     </filter>
     ```

3. **Secure Communication with TLS**:
   - Configure TLS for secure communication between Fluentd and Loki.

4. **Implement RBAC in Grafana**:
   - Set up role-based access control in Grafana to manage who can view logs, create dashboards, and set up alerts.

5. **Set Up Log Retention in Loki**:
   - Configure Loki to automatically delete logs after a specific retention period, ensuring that you comply with GDPR’s data retention requirements.

### **Step 3.2: Integrate Logging with Microservices**

1. **Configure Service Logging**:
   - Use Docker logging drivers to forward logs from your microservices to the centralized logging stack. For instance, you can use the `gelf` driver to send logs to Logstash:
     ```yaml
     services:
       fountainai:
         image: fountainai:v1
         logging:
           driver: "gelf"
           options:
             gelf-address: "udp://logstash:12201"
     ```

2. **Set Up Monitoring and Alerts**:
   - In Kibana or Grafana, configure monitoring dashboards and set up alerts for any suspicious activity or compliance issues based on the logs collected.

## **6. Step 4: Deploying Vapor Microservices with Secure HTTPS**

### **Step 4.1: Install and Configure Let's Encrypt**

1. **Install Certbot on the Manager Node**:
   - Install Certbot to manage SSL certificates:
     ```bash
     sudo snap install core; sudo snap refresh core
     sudo snap install --classic certbot
     sudo ln -s /snap/bin/certbot /usr/bin/certbot
     ```

2. **Obtain SSL Certificates**:
   - Use Certbot to obtain SSL certificates for your domain:
     ```bash
     sudo certbot certonly --standalone -d your-domain.com
     ```
   - Follow the prompts to complete the certificate issuance.

3. **Store Certificates as Docker Secrets**:
   - Convert the certificates to Docker Secrets:
     ```bash
     sudo docker secret create service_cert /etc/letsencrypt/live/your-domain.com/fullchain.pem
     sudo docker secret create service_key /etc/letsencrypt/live/your-domain.com/privkey.pem
     ```

### **Step 4.2: Deploy Services with HTTPS**

1. **Create Docker Compose File for Vapor Services**:
   - Write a `docker-compose.yml` file for your Vapor services, specifying the use of Docker Secrets for SSL:
     ```yaml
     version: '3.7'

     services:
       fountainai:
         image: fountainai:v1
         ports:
           - "443:443"
         secrets:
           - service_cert
           - service_key
         environment:
           - VAPOR_TLS_CERT_PATH=/run/secrets/service_cert
           - VAPOR_TLS_KEY_PATH=/run/secrets/service_key
     ```

2. **Deploy the Service Using Docker Stack**:
   - Deploy your services in Docker Swarm using the following command:
     ```bash
     sudo docker stack deploy -c docker-compose.yml fountainai
     ```

3. **Verify HTTPS Configuration**:
   - Access your service via `https://your-domain.com` to ensure it is served over HTTPS.

## **7. Step 5: Securing and Maintaining the Environment**

### **Step 5.1: Logging and Monitoring**

1. **Configure Docker Logging**:
   - Use JSON log drivers with rotation to manage logs on each node. Forward these logs to your centralized logging stack.

2. **Set Up Log Monitoring Tools**:
   - Install and configure tools like `fail2ban` to monitor for unauthorized access attempts and block suspicious IPs:
     ```bash
     sudo apt-get install fail2ban -y
     sudo nano /etc/fail2ban/jail.local
     ```
   - Configure the `[sshd]` section to monitor your custom SSH port:
     ```bash
     [sshd]
     enabled = true
     port = 2222
     logpath = /var/log/auth.log
     maxretry = 3
     bantime = 86400
     ```

3. **Enable UFW Logging**:
   - Enable logging in UFW to track denied connections:
     ```bash
     sudo ufw logging on
     ```

### **Step 5.2: Regular Maintenance**

1. **Automate Certificate Renewal**:
   - Set up a cron job to renew Let's Encrypt certificates automatically and update Docker Secrets:
     ```bash
     sudo crontab -e


     ```
   - Add the following entry to renew certificates every month:
     ```bash
     0 0 1 * * certbot renew --pre-hook "sudo docker service update --force fountainai" --post-hook "sudo docker secret update service_cert /etc/letsencrypt/live/your-domain.com/fullchain.pem && sudo docker secret update service_key /etc/letsencrypt/live/your-domain.com/privkey.pem"
     ```

2. **Audit and Rotate Secrets Regularly**:
   - Regularly audit your secrets and rotate them using the Golden Key to maintain security. Use the following command to update a Docker secret:
     ```bash
     sudo docker secret update db_password /etc/docker/secrets/db_password.enc
     ```

3. **Monitor System Performance and Security**:
   - Regularly check the status of your Docker Swarm, monitor resource usage, and review logs for any signs of unusual activity.

## **8. Conclusion**

This comprehensive guide provides a detailed blueprint for securely deploying FountainAI using Docker Swarm on Amazon Lightsail. By integrating a GDPR-compliant centralized logging system, securing all communications with HTTPS, and managing secrets with a Golden Key, you create a robust, secure, and compliant environment for running your microservices. This setup ensures that your infrastructure is resilient, scalable, and secure against modern threats, while also complying with stringent data protection regulations.
