# Wanderlust DevOps Automation 🚀

Automation of AWS infrastructure provisioning and server configuration for the **Wanderlust Mega Project** using **Terraform and Ansible**.

## 📌 Project Overview

The goal of this project is to replace repetitive manual infrastructure creation and software installation with a repeatable automation workflow.

### 🔧 Terraform

Terraform is used to provision the AWS infrastructure, including:

* VPC and networking
* Subnets
* Security Groups
* IAM Roles and Instance Profiles
* Master EC2 instance
* Jenkins Worker EC2 instance
* Amazon EKS Cluster
* EKS Managed Node Group
* EKS access configuration
* Required AWS resources

### ⚙️ Ansible

Ansible is used for software installation and server configuration.

The playbooks automate:

* Docker
* Jenkins
* AWS CLI
* kubectl
* eksctl
* SonarQube
* Trivy
* EKS kubeconfig configuration
* ArgoCD

## 🏗️ Automation Flow

```text
                Terraform
                    │
                    ▼
            AWS Infrastructure
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
   Master EC2             Jenkins Worker
        │
        │
        ▼
      Ansible
        │
        ▼
 Software Installation
 & Server Configuration
```

## 📁 Project Structure

```text
wanderlust-devops-automation/
│
├── terraform/
│   ├── provider.tf
│   ├── vpc.tf
│   ├── ec2.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── provisioners.tf
│   └── outputs.tf
│
├── ansible/
│   ├── master_setup.yaml
│   ├── jenkins_worker_setup.yaml
│   ├── update-kubeconfig.yaml
│   └── argocd_setup.yaml
│
└── .gitignore
```

## 🛠️ Technologies

* AWS
* Terraform
* Ansible
* Amazon EC2
* Amazon VPC
* IAM
* Amazon EKS
* Kubernetes
* Docker
* Jenkins
* SonarQube
* Trivy
* ArgoCD
* Linux

## 🚀 Deployment Approach

### 1. Provision Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure Servers

After the infrastructure is created, Ansible playbooks are used to install and configure the required DevOps tools.

```bash
cd ../ansible
```

Run the required playbooks according to the infrastructure outputs.

## 🎯 Objective

The main objective is to create a **repeatable and automated AWS DevOps environment** instead of manually provisioning infrastructure and installing tools on each server.

## 📚 Original Project

This automation work is based on the **Wanderlust Mega Project** by LondheShubham153.

[Original Wanderlust Mega Project](https://github.com/LondheShubham153/Wanderlust-Mega-Project?utm_source=chatgpt.com)

This repository focuses specifically on the **Terraform infrastructure provisioning and Ansible-based server/tool configuration** layer.
