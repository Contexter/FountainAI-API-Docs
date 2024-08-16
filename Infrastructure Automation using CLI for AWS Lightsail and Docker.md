# **Infrastructure Automation using CLI for AWS Lightsail and Docker**

## **1. Introduction**

As modern applications increasingly leverage cloud environments and containerization, the need for robust infrastructure automation becomes critical. Infrastructure as Code (IaC) allows teams to manage, configure, and deploy infrastructure resources consistently and repeatably. This paper explores the automation of infrastructure using Command Line Interfaces (CLI) for AWS Lightsail and Docker, focusing on setting up a Docker Swarm environment on Lightsail. The combination of these CLIs enables comprehensive automation from instance provisioning to container orchestration, ensuring a streamlined, scalable, and secure deployment process.

## **2. Overview of CLI Tools**

### **2.1 AWS CLI for Lightsail**

The AWS Command Line Interface (CLI) is a powerful tool that enables users to interact with AWS services from the command line. AWS CLI supports Lightsail, a service designed to simplify the deployment and management of cloud resources for small-scale applications.

- **Instance Management**: Provision, configure, and manage Lightsail instances.
- **Networking**: Automate the setup of networking components such as static IPs, DNS records, and security groups.
- **SSH Key Management**: Securely manage SSH keys for instance access.
- **Monitoring and Scaling**: Monitor instance performance and automate scaling based on demand.

AWS CLI documentation: [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-lightsail.html)

### **2.2 Docker CLI**

The Docker Command Line Interface (CLI) provides a range of commands to manage Docker containers, images, networks, and volumes. It is essential for managing containerized applications and deploying them in a scalable, automated manner.

- **Container Management**: Run, stop, and manage containers.
- **Image Management**: Build, tag, push, and pull Docker images.
- **Networking and Volumes**: Create and manage Docker networks and volumes.
- **Orchestration with Docker Swarm**: Manage multi-container applications and orchestrate them using Docker Swarm.
- **Secrets Management**: Securely manage sensitive data such as API keys and passwords using Docker secrets.

Docker CLI documentation: [Docker CLI Documentation](https://docs.docker.com/engine/reference/commandline/cli/)

## **3. Infrastructure Automation with AWS CLI for Lightsail**

### **3.1 Provisioning Lightsail Instances**

Automating the creation and configuration of Lightsail instances using the AWS CLI eliminates the need for manual intervention and ensures consistency across environments.

#### **Step 1: Create Lightsail Instances**

You can automate the provisioning of Lightsail instances using the `create-instances` command, specifying details such as the instance name, blueprint (operating system), instance plan, and user data for initialization.

Example:

```bash
aws lightsail create-instances \
    --instance-names "fountainai-manager" \
    --availability-zone "us-east-2a" \
    --blueprint-id "ubuntu_20_04" \
    --bundle-id "medium_2_0" \
    --user-data "#!/bin/bash
                 apt-get update -y
                 apt-get install -y docker.io
                 usermod -aG docker ubuntu"
```

This command creates a Lightsail instance named `fountainai-manager` with Ubuntu 20.04 LTS, a medium plan (2 GB RAM), and installs Docker during initialization.

#### **Step 2: Allocate Static IPs**

To ensure your instances have persistent IP addresses, you can automate the allocation of static IPs and attach them to your instances.

Example:

```bash
aws lightsail allocate-static-ip \
    --static-ip-name "manager-ip"
    
aws lightsail attach-static-ip \
    --static-ip-name "manager-ip" \
    --instance-name "fountainai-manager"
```

#### **Step 3: SSH Key Management**

Instead of manually managing SSH keys, use the AWS CLI to import your SSH key to Lightsail, making it available across all instances.

Example:

```bash
aws lightsail import-key-pair \
    --key-pair-name "FountainAIKey" \
    --public-key-base64 file://~/.ssh/lightsail_key.pub
```

This command imports the public key into Lightsail, which can be used for SSH access to instances.

### **3.2 Networking and Security Automation**

AWS CLI can automate the creation and management of networking components, ensuring that your environment is secure and accessible only via necessary ports.

#### **Step 1: Configure Security Groups**

Automate the creation and configuration of security groups to control access to your instances.

Example:

```bash
aws lightsail create-instances \
    --instance-names "fountainai-manager" \
    --availability-zone "us-east-2a" \
    --blueprint-id "ubuntu_20_04" \
    --bundle-id "medium_2_0" \
    --key-pair-name "FountainAIKey" \
    --user-data "#!/bin/bash
                 apt-get update -y
                 apt-get install -y docker.io
                 ufw allow 2222/tcp
                 ufw allow 443/tcp
                 ufw enable"
```

This script configures UFW (Uncomplicated Firewall) to allow only SSH and HTTPS traffic.

#### **Step 2: Automating DNS Configuration**

If using AWS Route 53 for DNS management, you can automate DNS record creation using the AWS CLI.

Example:

```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id Z3M3LMPEXAMPLE \
    --change-batch file://dns-changes.json
```

The `dns-changes.json` file contains the details of the DNS records to be created or updated.

### **3.3 Monitoring and Instance Management**

AWS CLI also supports monitoring and managing instances, allowing you to automate scaling and resource management based on performance metrics.

Example:

```bash
aws lightsail get-instance \
    --instance-name "fountainai-manager"
```

This command retrieves details about a specific instance, which can be used for monitoring or further automation scripts.

## **4. Infrastructure Automation with Docker CLI**

The Docker CLI enables comprehensive management and orchestration of containerized applications, making it an essential tool for deploying and maintaining applications in a Docker Swarm environment.

### **4.1 Container and Image Management**

Docker CLI provides robust tools for managing containers and images, which are critical for deploying and scaling applications.

#### **Step 1: Building and Managing Docker Images**

Automate the building of Docker images from a `Dockerfile` and manage their lifecycle, including tagging and pushing to a registry.

Example:

```bash
docker build -t fountainai:v1 .
docker tag fountainai:v1 my-repo/fountainai:v1
docker push my-repo/fountainai:v1
```

#### **Step 2: Running and Managing Containers**

Docker CLI commands allow you to run, stop, and manage containers across your infrastructure.

Example:

```bash
docker run -d --name fountainai-app -p 80:80 my-repo/fountainai:v1
docker stop fountainai-app
docker rm fountainai-app
```

These commands help manage application deployment and updates.

### **4.2 Networking and Volume Management**

Networking and persistent storage are crucial for multi-container applications, and Docker CLI provides extensive capabilities to manage these components.

#### **Step 1: Creating and Managing Networks**

Create and manage Docker networks to ensure containers can communicate securely within the Docker Swarm.

Example:

```bash
docker network create fountainai-net
docker network ls
```

#### **Step 2: Managing Volumes**

Docker volumes provide persistent storage for containers, and you can automate volume management with the Docker CLI.

Example:

```bash
docker volume create fountainai-data
docker volume ls
```

### **4.3 Orchestration with Docker Swarm**

Docker Swarm is a native clustering and orchestration tool for Docker. The Docker CLI provides commands to initialize, manage, and scale Docker Swarm clusters.

#### **Step 1: Initializing Docker Swarm**

Initialize Docker Swarm on the manager node using the Docker CLI.

Example:

```bash
docker swarm init --advertise-addr <manager-ip>
```

#### **Step 2: Joining Worker Nodes**

On each worker node, join the Docker Swarm using the token generated during initialization.

Example:

```bash
docker swarm join --token <swarm-token> <manager-ip>:2377
```

#### **Step 3: Deploying Stacks**

Docker Swarm uses stacks to deploy multi-container applications defined in a `docker-compose.yml` file.

Example:

```bash
docker stack deploy -c docker-compose.yml fountainai
```

#### **Step 4: Managing Services**

The Docker CLI allows you to scale, update, and manage services within Docker Swarm.

Example:

```bash
docker service scale fountainai_service=3
docker service update --image my-repo/fountainai:v1 fountainai_service
docker service ls
```

#### **Step 5: Secrets Management**

Securely manage secrets like passwords, API keys, and certificates using Docker Secrets.

Example:

```bash
echo "my-secret" | docker secret create db_password -
docker secret ls
```

### **4.4 Monitoring and Troubleshooting**

The Docker CLI includes tools for monitoring container performance, inspecting logs, and troubleshooting issues.

#### **Step 1: Inspecting Containers and Networks**

Get detailed information about containers and networks.

Example:

```bash
docker inspect fountainai-app
docker network inspect fountainai-net
```

#### **Step 2: Real-Time Monitoring**

Monitor the resource usage of containers in real-time.

Example:

```bash
docker stats
```

## **5. Integration and Automation Potential**

### **5.1 Combining AWS CLI and Docker CLI**

By integrating AWS CLI for Lightsail with Docker CLI, you can fully automate the deployment and management of containerized applications. This integration allows you to automate the entire lifecycle, from instance provisioning to container orchestration and monitoring.

#### **Step 1: Provision Instances and Set Up Docker**

Use AWS CLI to automate the provisioning of Lightsail instances and Docker installation, followed by Docker Swarm initialization and configuration using Docker CLI.

Example Script:

```bash
#!/bin/bash

# Provision Lightsail instances
aws lightsail create-instances ...
aws lightsail allocate-static-ip ...

# Install Docker and initialize Docker Swarm
ssh -i ~/.ssh/lightsail_key ubuntu@<manager-ip> << EOF
  sudo apt-get update -y
  sudo apt-get install -y docker.io
  sudo docker swarm init --advertise-addr <manager-ip>
EOF
```

#### **Step 2: Automate Deployment and Scaling**

Combine AWS CLI’s monitoring capabilities with Docker CLI to automate scaling based on load and performance.

Example:

```bash
# Monitor instance and scale services based on metrics
aws lightsail get-instance --instance-name "fountainai-manager" | grep "MetricName"
docker service scale fountainai_service=<desired-scale>
```

### **5.2 Full Automation Pipeline Example**

Here’s an example of how you can combine AWS CLI and Docker CLI into a single automation pipeline:

```bash
#!/bin/bash

# Provision Lightsail Instances
aws lightsail create-instances --instance-names "fountainai-manager" ...
aws lightsail allocate-static-ip --static-ip-name "manager-ip" ...

# SSH into Manager Node and Initialize Docker Swarm
ssh -i ~/.ssh/lightsail_key ubuntu@<manager-ip> << EOF
  sudo apt-get update -y
  sudo apt-get install -y docker.io
  sudo docker swarm init --advertise-addr <manager-ip>
EOF

# Join Worker Nodes to the Swarm
ssh -i ~/.ssh/lightsail_key ubuntu@<worker-ip> << EOF
  sudo docker swarm join --token <swarm-token> <manager-ip>:2377
EOF

# Deploy the Docker Stack
docker stack deploy -c docker-compose.yml fountainai

# Monitor and Scale the Services
while true; do
  # Monitor instance metrics
  metrics=$(aws lightsail get-instance --instance-name "fountainai-manager" | grep "MetricName")

  # Decision logic to scale services
  if [[ "$metrics" == *"HighCPU"* ]]; then
    docker service scale fountainai_service=5
  fi
  sleep 60
done
```

### **5.3 Benefits of Integration**

- **Consistency**: Ensures consistent infrastructure and deployment processes across environments.
- **Efficiency**: Reduces manual intervention, enabling faster deployment cycles.
- **Scalability**: Automates scaling decisions based on real-time metrics.
- **Security**: Leverages Docker Swarm secrets and secure SSH management to protect sensitive data.

## **6. Conclusion**

The combination of AWS CLI for Lightsail and Docker CLI provides a robust foundation for infrastructure automation, particularly in cloud-native environments. By automating everything from instance provisioning to container orchestration, you can achieve a highly efficient, scalable, and secure infrastructure setup for your applications. This approach not only streamlines operations but also enhances the reliability and performance of your deployed services. 

For more details on specific CLI commands and capabilities, refer to the official documentation for [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-lightsail.html) and [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/).



