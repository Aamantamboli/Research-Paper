# AWS Infrastructure Deployment (Manual vs Terraform)

## Overview

This project demonstrates how to create AWS infrastructure using two approaches:

1. Manual provisioning using the AWS Management Console (GUI)
2. Automated provisioning using Terraform (Infrastructure as Code)

The goal is to compare manual configuration with automated infrastructure deployment.

All resources are deployed in the AWS region **us-east-1 (N. Virginia)**.

---

# Infrastructure Architecture

The following AWS resources are created:

- 1 VPC
- 6 Public Subnets (each in a different Availability Zone)
- 1 Internet Gateway
- 1 Route Table
- 1 Security Group
- 1 EC2 Instance (t2.micro)
- 1 S3 Bucket

Architecture Diagram:

VPC (10.0.0.0/16)
│
├── Subnet 1 → us-east-1a
├── Subnet 2 → us-east-1b
├── Subnet 3 → us-east-1c
├── Subnet 4 → us-east-1d
├── Subnet 5 → us-east-1e
├── Subnet 6 → us-east-1f
│
├── Internet Gateway
│
├── Route Table
│    └── Route: 0.0.0.0/0 → Internet Gateway
│
├── Security Group
│    ├── SSH (22)
│    └── HTTP (80)
│
├── EC2 Instance (t2.micro)
│
└── S3 Bucket

---

# Part 1: Manual Infrastructure Creation (AWS Console)

Login to the AWS Management Console.

Set the region to **N. Virginia (us-east-1)**.

---

## Step 1: Create VPC

1. Open **VPC Dashboard**
2. Click **Create VPC**
3. Select **VPC Only**

Enter the following details:

Name: research-vpc  
IPv4 CIDR Block: 10.0.0.0/16

Click **Create VPC**

---

## Step 2: Create Subnets

Go to **Subnets → Create Subnet**

Select the VPC created earlier.

Create the following subnets:

Subnet 1  
CIDR: 10.0.1.0/24  
AZ: us-east-1a

Subnet 2  
CIDR: 10.0.2.0/24  
AZ: us-east-1b

Subnet 3  
CIDR: 10.0.3.0/24  
AZ: us-east-1c

Subnet 4  
CIDR: 10.0.4.0/24  
AZ: us-east-1d

Subnet 5  
CIDR: 10.0.5.0/24  
AZ: us-east-1e

Subnet 6  
CIDR: 10.0.6.0/24  
AZ: us-east-1f

After creating each subnet:

Enable **Auto Assign Public IP**

---

## Step 3: Create Internet Gateway

1. Go to **Internet Gateways**
2. Click **Create Internet Gateway**

Name: research-igw

Click **Create**

Attach it to your VPC:

Actions → Attach to VPC

Select **research-vpc**

---

## Step 4: Create Route Table

1. Go to **Route Tables**
2. Click **Create Route Table**

Name: public-route-table  
VPC: research-vpc

Click **Create**

---

## Step 5: Add Internet Route

Open the route table.

Go to **Routes → Edit Routes**

Add:

Destination: 0.0.0.0/0  
Target: Internet Gateway

Save changes.

---

## Step 6: Associate Subnets

Open the route table.

Go to **Subnet Associations**

Click **Edit Subnet Associations**

Select all 6 subnets.

Save.

---

## Step 7: Create Security Group

Go to **Security Groups → Create Security Group**

Name: research-sg  
VPC: research-vpc

Add Inbound Rules:

SSH  
Port: 22  
Source: 0.0.0.0/0

HTTP  
Port: 80  
Source: 0.0.0.0/0

Outbound Rules:

Allow All Traffic

Click **Create Security Group**

---

## Step 8: Launch EC2 Instance

Go to **EC2 Dashboard → Launch Instance**

Name: research-ec2

AMI: Amazon Linux 2

Instance Type: t2.micro

Network Settings:

VPC: research-vpc  
Subnet: public-subnet-1

Security Group: research-sg

Click **Launch Instance**

---

## Step 9: Create S3 Bucket

Go to **S3 → Create Bucket**

Enter:

Bucket Name: unique-research-bucket-name

Region: us-east-1

Leave other settings default.

Click **Create Bucket**

---

# Part 2: Terraform Infrastructure Deployment

Terraform automates the entire infrastructure creation process.

---

## Step 1: Install Terraform

Download Terraform from:

https://developer.hashicorp.com/terraform/downloads

Verify installation:

terraform -version

---

## Step 2: Install AWS CLI

Install AWS CLI.

Configure credentials:

aws configure

Enter:

AWS Access Key  
AWS Secret Key  
Default Region: us-east-1

---

## Step 3: Create Terraform Project

Project structure:

terraform-aws-research/

main.tf  
variables.tf  
outputs.tf  
terraform.tfvars

---

## Step 4: Initialize Terraform

Run:

terraform init

Terraform downloads the AWS provider.

---

## Step 5: Validate Configuration

Run:

terraform plan

This command shows which resources will be created.

---

## Step 6: Deploy Infrastructure

Run:

terraform apply

Type:

yes

Terraform will automatically create:

- VPC
- Subnets
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- S3 Bucket

---

## Step 7: Verify Resources

Login to AWS Console and verify that the resources have been created.

Check:

VPC  
Subnets  
Internet Gateway  
Route Table  
Security Group  
EC2 Instance  
S3 Bucket

---

# Destroy Infrastructure

To delete all resources:

terraform destroy

Type:

yes

---

# Conclusion

Manual provisioning requires multiple steps through the AWS Console and is time consuming.

Terraform allows infrastructure to be created automatically using code, improving:

- Speed
- Consistency
- Reproducibility
- Scalability

This experiment demonstrates the advantages of Infrastructure as Code (IaC) for cloud infrastructure management.

---
