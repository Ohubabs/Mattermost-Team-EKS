# Mattermost-Team-EKS

## Background

In my UT Austin Post-Graduate Cloud Computing course, I was given a project assignment to manually deploy an open source team collaboration website called Mattermost connected to a MYSQL database. For extra security, a bastion host design setup was to be used with the database installed on an instance within a private subnet leaving only the Mattermost website exposed to the internet by being installed on an instance running in a public subnet. In addition, the instructions stated that  provisioning of the instances and setting up the network configurations should be done via the AWS Management Console website. As a DevOps Engineer, I had a problem with the manual workflow of the project which made it time-consuming and error-prone. So, I decided to make a few changes. First instead of the AWS Management Console, I will use a popular Infrastructure-as-a-Code tool called Terraform to provision all cloud infrastructure. Next, in lieu of manually installing Mattermost and MYSQL directly onto Virtual Machines/Instances, I will be using containers of both software programs and deploying them within an EKS Kubernetes cluster for high level orchestration using helm charts. Then, I will securely expose the Mattermost web app to the internet with a custom url using an NGINX Ingress Controller that encrypts data moving in and out of the cluster using Lets Encrypt Certificates issued by Cert Manager deployed within the cluster. Finally, I will deploy Prometheus and Grafana to enable real-time monitoring of the Mattermost cluster's resources e.g. the containers running the mattermost app and MYSQL database.

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

1 – Launch an EC2 instance and install Terraform onto an AWS EC2 instance.

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

16 - Deploy the Nginx Ingresses for the Mattermost, Prometheus, & Grafana web apps to expose those apps to the internet.

17 - Confirm launch of encrypted mattermost website, setup login details and create an organization name 

18 - Confirm launch of prometheus website and monitoring of cluster resources.

19 - Confirm launch of grafana website, sync it with Prometheus as a datasource and enter a query to visualize prometheus monitoring data of the Mattermost Cluster and its resources.

20 - Clean up resources.





## Project Implementation

### Step 1: Launch an EC2 instance

- 1 Enter a Name for your instance and choose an OS for your instance. For my example, I used an Ubuntu 22.04 Instance type. This is primarily because as of 05/15/24 the hashicorp repository needed to install Terraform and Vault had not been updated to Ubuntu
24.04.

![Screenshot 2024-05-15 at 2 32 58 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/57a77812-716d-44a9-a81e-459d9eddd637)

- 2 Select an Instance Type, Recommended t3.medium, Create a key pair that'll be used to connect to your VM remotely. Select your VPC and security group (Recommend using the Defaults but ensure port 22 is open in the security group or you won't be able to connect to the VM).

![Screenshot 2024-05-15 at 2 41 15 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/931fc33b-1058-4ffd-9ead-035d846de72c)

- 3 Configure your EBS storage to be greater than the standard 8GB provided for the t3.medium instance as you will need a lot of space to execute the terraform commands. Afterwards, Launch your instance. Then follow the steps to connect remotely to the instance from your terminal. Substituting in your key pair name and instance public dns/ip.

![Screenshot 2024-05-15 at 2 42 22 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/d5900267-fc29-4ce1-a2d4-a32b7e734f91)

![Screenshot 2024-05-15 at 2 45 18 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/fb4b2064-ef2b-4e4c-be9b-f6fb36fc3c75)

![Screenshot 2024-05-15 at 2 48 28 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b79c16b8-2a10-45c4-9aed-260d26d2ceac)

### Step 2: Clone this repository

    git clone https://github.com/Ohubabs/Mattermost-Team-EKS.git

![Screenshot 2024-05-15 at 3 28 48 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e38fb179-7b4c-4ea9-a7d3-14af4d4f80fd)



### Step 3: Install AWS CLI v2

To install AWS cli v2 and login to AWS account, execute the following commands:
	
    sh aws.sh 

![Screenshot 2024-05-15 at 3 30 08 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e80a13bb-f50d-4bc9-b5c5-9741d2823474)

After installing AWS cli v2, setup access to your AWS account by executing the bash shell script below then entering the necessary information when prompted
	
    aws configure

![Screenshot 2024-05-15 at 3 32 33 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/510d6f8c-ffef-41bd-bb50-ec1ce083f971)

Enter you AWS Account Access ID, Secret Key, region for deploying your resources, and output type (Recommend: json)

To confirm the installation, run:

    aws --version

![Screenshot 2024-05-15 at 3 31 09 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/4c73a466-db09-4da4-8c32-4e7533671d39)


### Step 4: Install Kubectl CLI

Install Kubectl CLI by executing the bash shell script below:

    sh kubectl.sh 

![Screenshot 2024-05-15 at 3 34 05 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/777a0c44-cdcb-48bf-9147-160b0e7bd994)

Confirm installation by executing the kubectl command:

    kubectl version

 ![Screenshot 2024-05-15 at 3 34 37 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/6b5196f4-5de3-4da7-ac81-e99c384a183d)



### Step 5: Install Terraform CLI by executing the bash shell script below

    sh terraform.sh

![Screenshot 2024-05-15 at 3 42 59 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/1f1cb16b-e693-4403-823e-5832f293eb33)
![Screenshot 2024-05-15 at 3 43 06 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/71010547-1ce9-4664-8cf0-e0fac5d59565)


### Step 6 – Deploy Mattermost EKS Cluster and VPC with necessary permissions via IAM Service accounts to configure pods with access to EBS storage, VPC networking, Route53 for creating website url, and Application LoadBalancer to handle web traffic into and out of the cluster for deployed applications. Note:- It will take 10 – 20 mins for your cluster to be deployed.

Enter the eks/ directory
Edit var.tf by entering a custom key pair you've created in AWS to setup remote ssh access to your nodes.
Execute the following commands:
	
    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 3 47 31 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/96ea8eee-0fae-4ee5-8e4d-766aa6368d5c)
![Screenshot 2024-05-15 at 3 51 35 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/6bd97edc-066f-4cc3-9efa-8417a62c8b60)
![Screenshot 2024-05-15 at 3 53 09 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/d6bfb92a-a6fb-4e63-882e-c560385405cf)
![Screenshot 2024-05-15 at 3 53 42 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/02677d4b-61e4-497c-84fc-9cdf44a28ab5)
![Screenshot 2024-05-15 at 3 55 23 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/3dcff2f1-4cca-4561-b079-5784307004ce)
![image](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/264962eb-4932-46a5-ae40-dc5e98e9a3de)
![Screenshot 2024-05-15 at 4 05 14 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/0ad34313-356e-43af-b766-dbc28ff5e386)
![Screenshot 2024-05-15 at 4 05 31 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/ccb99f18-4833-4698-a738-1d0e4e268d81)
![Screenshot 2024-05-15 at 4 08 52 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/dd1ee9ea-522b-4d95-8a5e-89038d30b95e)
![Screenshot 2024-05-15 at 5 19 59 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/7ed98ec5-758f-4877-a957-5ec97b97694d)
![Screenshot 2024-05-15 at 4 11 19 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/16f9b741-d3b8-4288-8d52-7218a5084d18)


### Step 7: Update Kubeconfig after cluster deployment by executing the aws commad:

    aws eks update-kubeconfig --name <name-of-cluster> --region <region-of-cluster-deployment>



### Step 8: Setup Namespaces within Mattermost Cluster.

Enter the namespace/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 4 18 52 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/bbce49ba-61f5-44e1-9b03-1610aead5d3b)
![Screenshot 2024-05-15 at 4 19 31 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/faf40e55-ebff-4b86-9ec0-457bfc36c2fb)
![Screenshot 2024-05-15 at 4 19 36 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/527a7e09-1e15-4e1c-85ac-58eabaef1f1e)
![Screenshot 2024-05-15 at 4 19 48 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c4c79114-12c6-47ef-b36f-b9363670f752)
![Screenshot 2024-05-15 at 4 19 56 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/f502212a-6e43-434d-9cd9-f933167cfd39)


### Step 9: Setup Secrets within Mattermost Cluster.

Enter the auth/ directory
Edit the var.tf file with your aws credentials and the login details you wish to use for Grafana. If you want to change the name of the secret, make sure to change the name in the Grafana values file and in the matt-issuer.yml and observe-issuer.yml
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 4 24 42 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c9586131-d2bf-4cc9-96b6-2a1e4a0f5819)
![Screenshot 2024-05-15 at 4 25 04 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/3f4057f2-3985-4548-bb59-11886bdff53c)
![Screenshot 2024-05-15 at 4 25 10 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/f1375320-fb78-4602-8ac7-6194c01f230c)
![Screenshot 2024-05-15 at 4 25 19 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c14a5f76-2066-4a0d-916a-66f03039651a)
![Screenshot 2024-05-15 at 4 25 33 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/73041609-dbd3-4060-84bd-b40c68b76087)
![Screenshot 2024-05-15 at 4 27 32 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c0409549-b200-411a-966d-da634a5e92a3)


### Step 10: Deploy the External DNS helm chart to handle setting up apps within the Mattermost Cluster with domain names/website url for easy access on the internet. 
Enter the exposure/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 4 53 02 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/9ad80f3f-0249-48f5-b391-40b2deef226c)
![Screenshot 2024-05-15 at 4 53 41 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/10c2552c-d36a-46d5-a93c-a81903bb36b7)
![Screenshot 2024-05-15 at 4 54 32 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/669f0525-9738-47fd-89bc-56d40d718772)
![Screenshot 2024-05-15 at 4 56 12 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c338dcc8-cd20-484b-b176-f86722b2d0b4)



### Step 11: Deploy the Certificate Manager Helm Chart to handle the issuing of Lets Encrypt certificates to secure apps within the Mattermost Cluster exposed to the internet as websites. Note you need to have your own Domain Name setup in Route53 on AWS. Once you have setup your domain, replace  ".devopsnetwork.net" with your own website url. Note:- You can install the helm chart without the service account entry. Only use it if you used the cert-manager module create the IAM IRSA service account role svc.tf file of the eks/ directory


Enter the encryption/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 4 39 44 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/63ef0069-cc40-412b-8ad4-8ffb88209a5a)
![Screenshot 2024-05-15 at 4 40 32 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/be2291eb-5383-48f6-a036-2a5b6b01c772)
![Screenshot 2024-05-15 at 4 43 55 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/955a2ad8-f468-4aec-a319-a326150ac85a)
![Screenshot 2024-05-15 at 4 43 58 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/267811d3-55cd-42ce-99ac-6ff3eb738ea7)

Then run these kubectl commands to create two clusterissuers to encrypt web traffic flowing through the loadbalancers created in step 16.

    kubectl apply -f matter-issuer.yml
    kubectl apply -f observe-issuer.yml

![Screenshot 2024-05-15 at 5 05 47 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/59cc50d1-7512-4d1e-851a-84b5c95347ba)
![Screenshot 2024-05-15 at 5 06 47 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/cab6425b-68e1-4307-a3a3-52b1665b22ad)


### Step 12: Deploy the Application LoadBalancer Helm Chart to enable the provisioning of Application LoadBalancers on AWS for handling the web traffic going in and coming out to applications running in pods within the Mattermost Cluster:

Enter the alb/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 5 13 59 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/bcf665e6-1677-4044-9a7d-c5b58caf3c92)
![Screenshot 2024-05-15 at 5 13 59 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/92c1a4e1-5daf-49a2-970a-620b91f6367a)
![Screenshot 2024-05-15 at 5 15 07 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/1b548737-85c4-4685-96ef-eca5494b21aa)
![Screenshot 2024-05-15 at 5 15 24 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/4aaac444-5188-4cae-8693-995d025333f8)
![Screenshot 2024-05-15 at 5 09 34 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/97c70d36-abd8-402a-8278-2ca3a425edb7)
![Screenshot 2024-05-15 at 5 15 58 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/28bd378f-2ca6-47af-9a9f-6f3910f3b38d)

### Step 13: Deploy the Nginx-Ingress Helm Chart to handle the traffic in and out to applications running in pods within the Mattermost Cluster:

Enter the nginx-ingress/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 5 22 42 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/07963c7c-3f52-476b-86ea-af93d615f3a5)
![Screenshot 2024-05-15 at 5 26 48 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/d0edfa9b-144b-4f04-85f2-ae957683b93a)
![Screenshot 2024-05-15 at 5 28 09 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/67004bd8-078f-4749-b59a-38c6a154e6e8)
![Screenshot 2024-05-15 at 5 28 49 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/82372bf8-febf-4eb3-b789-4523fcbee4f2)



### Step 14: Deploy the Mattermost Helm Chart with embedded MYSQL database:

Enter the mattermost/ directory
Edit the mattermost-values.yml file by entering the credentials for the embedded mysql database and the storageclass names for Mattermost & MYSQL so their pods can be dynamically provisioned EBS storage.
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 5 36 18 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/694d7a1f-929b-46fc-afb0-ca46e3570959)
![Screenshot 2024-05-15 at 5 36 44 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/66ecebb7-3396-4afc-b89d-b2c270140bf4)
![Screenshot 2024-05-15 at 5 37 11 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/11292bf7-2d73-4836-b636-e86926af57f0)
![Screenshot 2024-05-15 at 5 48 09 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/bf4f6a4a-3e00-4208-b112-41b1a667c376)

### Step 15: Deploy the Prometheus and Grafana Helm Charts to perform real time monitoring of all cluster resources:

Enter the observability/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 5 49 59 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/97ab9ff8-6f94-4d6e-ad5b-b69c9e0dbbeb)
![Screenshot 2024-05-15 at 5 50 17 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/aa628fd7-dfa9-4f9d-813d-8713792b44b9)
![Screenshot 2024-05-15 at 5 51 43 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e887898b-dd70-4baa-b159-5eea1ace25d9)
![Screenshot 2024-05-15 at 5 54 00 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/f13ed271-4386-4087-8334-be6d59386045)
![Screenshot 2024-05-15 at 5 59 25 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b96530e0-7372-44bb-be30-be24f08d7709)



### Step 16: Deploy the Nginx Ingresses for Mattermost, Prometheus & Grafana to expose those apps to the internet to at matter.devopsnetwork.net, matter-monitor.devopsnetwork.net, matter-dashboard.devopsnetwork.net.:

Enter the ingress/ directory
Execute the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve

![Screenshot 2024-05-15 at 6 07 31 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c388a39c-baa1-4f94-8653-d185893ef2bb)
![Screenshot 2024-05-15 at 6 03 29 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/a11ed7dc-8fe2-4d87-9675-20e8d86a7a8b)
![Screenshot 2024-05-15 at 6 03 46 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/166a805c-3a35-4f2c-b033-f6350abb2e06)
![Screenshot 2024-05-15 at 6 04 54 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/6f14fc45-8ece-4bed-9cc1-7a81647b825f)

### Step 17: Confirm launch of encrypted mattermost website, setup login details and create an organization name

![Screenshot 2024-05-15 at 6 46 45 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b5310e94-1961-4fa1-babf-895a0b6940bc)
![Screenshot 2024-05-15 at 6 49 28 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/c727a7ff-e296-4e00-b7d6-f8bf177ea7d8)
![Screenshot 2024-05-15 at 6 49 49 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/7d814431-55fc-4024-bf25-280d06449c13)
![Screenshot 2024-05-15 at 6 50 51 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/795dc242-7a6d-4cd5-a2d5-1f1a9e48e2a9)

### Step 18: Confirm launch of prometheus website and monitoring of cluster resources.

![Screenshot 2024-05-15 at 6 46 56 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/35c80baa-5989-4c22-b30d-6a2c28a79279)
![Screenshot 2024-05-15 at 7 01 54 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/0e258048-5be5-4b79-b587-da6e111a0bde)
![Screenshot 2024-05-15 at 7 01 32 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b2c9cf49-5aab-49d9-91fa-9c4c06d127f6)


### Step 19: Confirm launch of grafana website, sync it with Prometheus as a datasource and enter a query to visualize prometheus monitoring data of the Mattermost Cluster and its resources.

![Screenshot 2024-05-15 at 6 47 03 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/6fec0e23-ab51-45f0-a48f-eefd716f40fd)
![Screenshot 2024-05-15 at 7 06 05 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/d1990468-8252-4eec-a1d3-bb2f50a53c87)
![Screenshot 2024-05-15 at 7 06 13 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/0560b88d-77bd-40c3-b3f1-ffac20dc38c4)
![Screenshot 2024-05-15 at 7 06 23 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/0531f4b9-62a1-446f-834f-f4a8e6542a09)
![Screenshot 2024-05-15 at 7 06 29 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/de04c3e8-5a69-4a31-80b5-2ba5618e09f0)
![Screenshot 2024-05-15 at 7 06 40 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/e5cbe778-7d05-45cb-ba35-c801931a7c14)
![Screenshot 2024-05-15 at 7 06 43 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/476ec7ad-d551-4b05-b8c8-e346c87f28b2)
![Screenshot 2024-05-15 at 7 10 30 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/2ab40cc6-f1b1-467c-8cda-95b3975dc916)
![Screenshot 2024-05-15 at 7 11 21 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/b96ad9ae-7b0a-4004-a053-23ab5c1c982b)
![Screenshot 2024-05-15 at 7 16 24 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/3fdadc70-0fb8-4b75-bf8c-adf7fd2bbf43)
![Screenshot 2024-05-15 at 7 25 12 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/57dec34f-0b02-45db-8c0b-4b417c072974)
![Screenshot 2024-05-15 at 7 25 39 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/98d28148-5ed2-46fe-a0d7-343cd113820b)
![Screenshot 2024-05-15 at 7 28 44 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/6461797e-be76-48c2-8c5d-bd00d949bf10)
![Screenshot 2024-05-15 at 7 34 22 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/9104493a-c8aa-4928-a572-5db70bf578a6)
![Screenshot 2024-05-15 at 7 38 35 PM](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/ec2c4773-9f51-4b14-9dbe-b97fe60c4f79)

### Step 20: Clean up resources.

Delete resources by performing running the command below in each directory following this order 

    terraform destroy --auto-approve

- ingress/
- observability/
- mattermost/
- nginx-Ingress/
- alb/
- encryption/
- expose/
- auth/
- namespace/
- eks/












![image](https://github.com/Ohubabs/Mattermost-Team-EKS/assets/68171102/1923fac3-3f3c-4183-8baf-dac3fee0b5b3)
