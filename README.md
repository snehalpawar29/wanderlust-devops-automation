# 🚀 Wanderlust Mega Project — DevOps Automation

A **three-tier MERN application** deployed and automated using AWS, Terraform, Ansible, Docker, Kubernetes, and DevOps tools.

> Application based on the original [Wanderlust Mega Project](https://github.com/LondheShubham153/Wanderlust-Mega-Project).
> This repository focuses on my **DevOps automation and infrastructure work**.

## 🏗️ Architecture

```text
Terraform
    ↓
AWS Infrastructure
    ↓
EC2 + EKS
    ↓
Ansible
    ↓
Jenkins | SonarQube | Trivy | ArgoCD
    ↓
Docker
    ↓
Frontend | Backend | MongoDB | Redis
```

## 🛠️ Tech Stack

**AWS | Terraform | Ansible | Docker | Kubernetes | EKS | Jenkins | SonarQube | Trivy | ArgoCD | MongoDB | Redis | Nginx**

## ⚙️ DevOps Work

* Provisioned AWS infrastructure using **Terraform**
* Configured EC2 servers and DevOps tools using **Ansible**
* Created and configured **Amazon EKS** cluster and node group
* Automated Kubernetes access and **ArgoCD** installation
* Containerized the application using **Docker**
* Created optimized multi-stage Docker builds
* Reduced frontend image size **718 MB → 94.9 MB (~86.8%)**
* Reduced backend image size **427 MB → 368 MB (~13.8%)**
* Created Docker Compose setup with custom networking and persistent MongoDB storage
* Prepared environment for **CI/CD and DevSecOps**

## 📁 Structure

```text
Wanderlust-Mega-Project/
├── backend/
├── frontend/
├── terraform/
├── ansible/
├── docker-compose.yml
└── README.md
```

## 🚀 Run with Docker Compose

```bash
docker compose up -d
```

Check containers:

```bash
docker compose ps
```

Stop:

```bash
docker compose down
```

## 🔗 Repository

**DevOps Automation:**
https://github.com/snehalpawar29/wanderlust-devops-automation

**Original Project:**
https://github.com/LondheShubham153/Wanderlust-Mega-Project

## 👨‍💻 Author

**Snehal Pawar**
Aspiring DevOps / Cloud Engineer

GitHub: https://github.com/snehalpawar29
LinkedIn: https://linkedin.com/in/snehalpawar29
