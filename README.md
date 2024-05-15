# Mattermost-Team-EKS

## Background

In my UT Austin Post-Graduate Cloud Computing course, I was given a project assignment to manually deploy an open source team collaboration website called Mattermost connected to a MYSQL database. For extra security, a bastion host design setup was to be used with the database installed on an instance within a private subnet leaving only the Mattermost website exposed to the internet. In addition, the instructions stated that  provisioning of the instances and setting up the network configurations should be done via the AWS Management Console website. As a DevOps Engineer, I had a problem with the manual workflow of the project which made it time-consuming and error-prone. So, I decided to make a few changes. First instead of the AWS Management Console, I will use a popular Infrastructure-as-a-Code tool called Terraform to provision all cloud infrastructure. Next, in lieu of manually installing Mattermost and MYSQL, I will be using containers of both software programs and deploying them within an EKS Kubernetes cluster for high level orchestration. Then, I will securely expose the Mattermost web app to the internet with a custom url using an NGINX Ingress Controller that encrypts data moving in and out of the cluster using Lets Encrypt Certificates issued by Cert Manager deployed within the cluster. Finally, I will deploy Prometheus and Grafana to enable real-time monitoring of the cluster  

## Project Scenario

You are working at a small enterprise with 50 or less employees. To help development teams across the organization collaborate and communicate effectively while aligning with the company’s security policies, the management team has instructed the IT department to launch Mattermost Team Edition. Mattermost is an open source platform that provides secure collaboration for technical and operational teams that work in environments with complex nation-state level security and trust requirements. Mattermost is built specifically for technical and operational use cases, including software development and engineering workflows, and integrates deeply with a rich ecosystem of third-party developer tools. Mattermost gives companies full control over their data; with self-hosted and private cloud deployment options and access to the source code, developers can contribute directly to a shared, flexible, and extensible platform built just for them. With Mattermost Team Edition, the free open-source version, organizations get to enjoy the following benefits:-

-	Teams and channels for one-to-one and group messaging, file sharing, and unlimited search history with threaded messaging, emoji, and custom emoji.
-	Native apps for iOS, Android, Windows, macOS, and Linux.
-	Pre-packaged integrations with most common developer tools, including Jira, Confluence, GitHub, GitLab, CircleCI, Zoom, Jitsi, and more.

For more information, checkout the mattermost: https://docs.mattermost.com/about/editions-and-offerings.html
Mattermost website: https://mattermost.com/

## Software Tools needed

-	AWS Cli v2
-	Kubectl Cli
-	Terraform Cli
-	AWS EKS Cluster
-	Kubernetes cluster add-ons External DNS, Certificate Manager, Application LoadBalancer Controller, and Nginx Ingress Controller to securely expose apps within the cluster to the internet with 	custom urls
-	Monitoring Software

## Project Instructions

1 – Launch an EC2 instance and install Terraform onto the VM

2 – Once the instance is setup, clone this repository

3 –  Execute the bash script for installing the aws cli v2 to enable terraform to communicate with the AWS website via its API.

4 - Execute the bash script for installing  Kubectl Cli to interact with the Kubernetes cluster after provisioning.

5 - Execute the bash script for installing the Terraform CLI for provisioning cloud resources on AWS using code and Vault CLI for extra security.

6 – Deploy the Mattermost Cluster within the Mattermost VPC and necessary permissions for setting up pods with EBS storage, VPC CNI networking, and Application LoadBalancer exposure.

7 – After cluster deployment, update kubeconfig file

8 – Setup Cluster Namespaces 

9 – Setup Cluster Secrets 

10 – Deploy External DNS helm chart.

11 – Deploy Certificate Manager helm chart.

12 – Deploy Application LoadBalancer Controller helm chart.

13 – Deploy Nginx Ingress Controller helm chart.

14 – Deploy Mattermost helm chart with embedded MYSQL Database helm chart.

15 – Deploy Observability Software Prometheus and Grafana for real time monitoring of cluster resources i.e. pods, nodes, nginx ingress controller, etc…





## Project Implementation

### Step 1: Launch an EC2 instance

- 1 Enter a Name for your instance and choose an OS for your instance. For my example, I used an Ubuntu 22.04 Instance type. This is primarily because as of 05/15/24 the hashicorp repository needed to install Terraform and Vault had not been updated to Ubuntu
24.04.

![Screenshot 2024-05-15 at 2 32 58 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/57a77812-716d-44a9-a81e-459d9eddd637)

- 2 Select an Instance Type, Recommended t3.medium, Create a key pair that'll be used to connect to your VM remotely. Select your VPC and security group (Recommend using the Defaults but ensure port 22 is open in the security group or you won't be able to connect to the VM).

![Screenshot 2024-05-15 at 2 41 15 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/931fc33b-1058-4ffd-9ead-035d846de72c)

- 3 Configure your EBS storage to be greater than the standard 8GB provided for the t3.medium instance as you will need a lot of space to execute the terraform commands. Afterwards, Launch your instance. Then follow the steps to connect remotely to the instance from your terminal. Substituting in your key pair name and instance public dns/ip.

![Screenshot 2024-05-15 at 2 42 22 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/f4e14bd2-7d4c-485c-b934-70a9040fca44)

![Screenshot 2024-05-15 at 2 45 18 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/fb4b2064-ef2b-4e4c-be9b-f6fb36fc3c75)

![Screenshot 2024-05-15 at 2 48 28 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b79c16b8-2a10-45c4-9aed-260d26d2ceac)

### Step 2: Clone this repository

    git clone https://github.com/Ohubabs/Mattermost-Team-EKS.git

![Screenshot 2024-05-15 at 3 28 48 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e38fb179-7b4c-4ea9-a7d3-14af4d4f80fd)



### Step 3: Install AWS CLI v2

To install AWS cli v2 and login to AWS account, execute the following commands:
	
    sh aws.sh 

![Screenshot 2024-05-15 at 3 30 08 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e80a13bb-f50d-4bc9-b5c5-9741d2823474)

![Screenshot 2024-05-15 at 3 31 09 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/4c73a466-db09-4da4-8c32-4e7533671d39)

After installing AWS cli v2, setup access to your AWS account by executing the bash shell script below then entering the necessary information when prompted:
	
    aws configure

![Screenshot 2024-05-15 at 3 32 33 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/510d6f8c-ffef-41bd-bb50-ec1ce083f971)



Enter you AWS Account Access ID, Secret Key, region for deploying your resources, and output type (Recommend: json)

### Step 4: Install Kubectl CLI

Install Kubectl CLI by executing the bash shell script below:

    sh kubectl.sh 

![Screenshot 2024-05-15 at 3 34 05 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/777a0c44-cdcb-48bf-9147-160b0e7bd994)


### Step 5: Install Terraform CLI by executing the bash shell script below

    sh terraform-vault.sh

### Step 6 – Deploy Mattermost EKS Cluster and VPC with necessary permissions via IAM Service accounts to configure pods with access to EBS storage, VPC networking, and Application LoadBalancer Network Trafficking to expose deployed applications to the internet. Note:- It will take 10 – 20 mins for your cluster to be deployed.

Enter the eks/ directory
Execute the following commands:
	
    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 7: Update Kubeconfig after cluster deployment by executing the aws commad:

    aws eks update-kubeconfig --name <name-of-cluster> --region <region-of-cluster-deployment

### Step 8: Setup Namespaces within Mattermost Cluster.

Enter the namespace/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 9: Setup Secrets within Mattermost Cluster.

Enter the auth/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 10: Deploy the External DNS helm chart to handle setting up apps within the Mattermost Cluster with domain names/website url for easy access on the internet.

Enter the exposure/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 11: Deploy the Certificate Manager Helm Chart to handle the issuing of Lets Encrypt certificates to secure apps within the Mattermost Cluster exposed to the internet as websites.

Enter the encryption/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve


### Step 12: Deploy the Application LoadBalancer Helm Chart to enable the provisioning of Application LoadBalancers on AWS for handling the web traffic going in and coming out to applications running in pods within the Mattermost Cluster:

Enter the alb/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 13: Deploy the Nginx-Ingress Helm Chart to handle the traffic in and out to applications running in pods within the Mattermost Cluster:

Enter the nginx-ingress/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

### Step 14: Deploy the Mattermost Helm Chart with embedded MYSQL database:

Enter the mattermost/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve


### Step 15: Deploy the Prometheus and Grafana Helm Charts to perform real time monitoring of all cluster resources:

Enter the observability/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve
![image](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/1923fac3-3f3c-4183-8baf-dac3fee0b5b3)
