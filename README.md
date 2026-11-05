# 🌍 Wanderlust — DevSecOps & GitOps Automation

<p align="center">
  <strong>Rebuilding the delivery platform with Infrastructure as Code, CI/CD, Security Automation and GitOps.</strong>
  <br/><br/>
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws" />
  <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform" />
  <img src="https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible" />
  <img src="https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins" />
  <img src="https://img.shields.io/badge/Docker-Containers-2496ED?logo=docker" />
  <img src="https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes" />
  <img src="https://img.shields.io/badge/Argo%20CD-GitOps-EF7B4D?logo=argo" />
</p>

<p align="center">
  <a href="https://github.com/snehalpawar29/wanderlust-devops-automation">My DevOps Implementation</a>
  &nbsp; • &nbsp;
  <a href="https://github.com/LondheShubham153/Wanderlust-Mega-Project">Original Application</a>
</p>

---

## 🏗️ Architecture

<p align="center">
  <img src="Assets/Architecture_Diagram.png" alt="Wanderlust DevSecOps and GitOps Architecture" width="100%" />
</p>

---

## 🎯 Project Overview

The original Wanderlust MERN travel-blog application and its deployment walkthrough are credited to [LondheShubham153](https://github.com/LondheShubham153). I used that project as the application and learning reference, then rebuilt the DevOps and deployment side in my own repository.

My goal was to move away from manually creating AWS resources and installing/configuring tools step by step, and create a more repeatable workflow: provision infrastructure with Terraform, configure EC2 and Kubernetes tooling with Ansible, run security and code-quality checks in Jenkins, package optimized Docker images, and deploy Kubernetes changes through GitHub and Argo CD.

The original application is credited to its owner; this repository focuses on my infrastructure, automation, containerization, CI/CD and GitOps implementation.

---

## 🚀 What I Improved

### 1. ☁️ Terraform + Ansible — Infrastructure Automation

I automated AWS infrastructure provisioning and server configuration using Terraform and Ansible, replacing much of the original workflow's manual resource creation and tool installation with reusable automation.

**✨ What I changed**

- **Terraform:** Declared the VPC, subnets across two Availability Zones, NAT Gateway, security groups, EC2 instances, IAM roles and instance profiles, EKS cluster, managed node group, OIDC provider and EKS access configuration as code.
- **Ansible:** Automated Jenkins master setup with Docker, Jenkins, AWS CLI, Kind, kubectl, eksctl and SonarQube.
- **Worker configuration:** Automated Docker, AWS CLI and Trivy installation.
- **EKS configuration:** Automated kubeconfig setup and Argo CD installation.
- **Repeatability:** Kept infrastructure definitions and configuration playbooks in the repository instead of relying only on console actions and manual shell commands.

#### 📊 Infrastructure Setup-Time Comparison

<p align="center">
  <img src="Assets/infrastructure-setup-comparison.png" alt="Infrastructure setup-time comparison" width="85%" />
</p>

| Workflow | Recorded Time |
| :--- | :--- |
| Original manual setup | 33 minutes |
| Terraform + Ansible automation | 11 minutes |

<p align="center">
  <strong>📉 66.7% calculated reduction in recorded setup time</strong>
</p>

The percentage is calculated from the recorded 33-minute manual setup and 11-minute automated setup. The manual timing excluded VPC setup, while the current Terraform configuration also creates the VPC. This is an indicative recorded comparison, not a controlled like-for-like benchmark.

---

### 2. 🐳 Dockerfiles — Image Optimization

I redesigned the frontend and backend Dockerfiles to keep build-time dependencies and tools out of the final runtime images.

**✨ What I changed**

**🎨 Frontend**

- Used a multi-stage build with `node:22-alpine`.
- Installed dependencies using `npm ci`.
- Built the frontend using `npm run build`.
- Used `nginx:alpine` as the final runtime image.
- Copied only the compiled `dist/` assets into the final image.

**⚙️ Backend**

- Used a multi-stage build with `node:22-slim`.
- Installed dependencies using `npm ci`.
- Used `npm ci --omit=dev` in the production stage.
- Copied only the required runtime directories into the final image.

#### 📊 Docker Image-Size Comparison

<p align="center">
  <img src="Assets/docker-image-size-comparison.png" alt="Docker image-size comparison" width="85%" />
</p>

| Application | Original Image | My Image | Reduction |
| :--- | :--- | :--- | :--- |
| Frontend | 718 MB | 94.9 MB | 86.8% |
| Backend | 427 MB | 368 MB | 13.8% |

<p align="center">
  <strong>🎯 Smaller runtime images with fewer unnecessary build dependencies.</strong>
</p>

The reductions are calculated from the before-and-after image sizes recorded for this project.

---

### 3. 🔧 Jenkins — CI Pipeline Automation

The original reference uses separate Jenkins CI and CD jobs. I brought the main validation, image build/push and Kubernetes manifest-update steps into one Jenkins pipeline using a Jenkins Shared Library and a worker agent labelled `Node`.

**✨ What I changed**

- 📥 Cleaned the workspace and checked out the main branch.
- 🛡️ Integrated Trivy filesystem scanning.
- 🔐 Added OWASP Dependency-Check for dependency vulnerability analysis.
- 📊 Integrated SonarQube analysis and quality-gate validation.
- ⚡ Built frontend and backend Docker images in parallel.
- 📦 Pushed both images to Docker Hub in parallel.
- 🔄 Updated Kubernetes deployment image tags and committed manifest changes back to GitHub.
- 📧 Added email notifications and workspace cleanup.

**💡 Why this is better**

- Maintains pipeline stages in a single version-controlled Jenkinsfile.
- Uses reusable Shared Library functions to reduce repeated pipeline code.
- Runs frontend and backend image builds and pushes in parallel.
- Provides updated Kubernetes manifests in GitHub for Argo CD to reconcile.

---

### 4. 🚀 Argo CD — GitOps Deployment on Amazon EKS

I integrated Argo CD with Amazon EKS to manage application deployment using Git as the desired-state source.

**✨ What I changed**

- Installed and configured Argo CD through an Ansible playbook.
- Created the `argocd` namespace.
- Applied the Argo CD installation manifest.
- Waited for Argo CD pods to become Ready.
- Connected Argo CD to the GitHub repository containing Kubernetes manifests.
- Used Git as the desired-state source for application deployment.
- Synchronized Kubernetes manifests with Amazon EKS.

#### 🔄 CI + GitOps Workflow

```text
Developer pushes code
        |
        v
     GitHub
        |
        v
      Jenkins
        |
        +----------------------+
        |                      |
        v                      v
  Security Scans         SonarQube
        |                      |
        +----------+-----------+
                   |
                   v
          Docker Image Builds
             (Parallel)
                   |
                   v
             Docker Hub
                   |
                   v
       Update Kubernetes Manifests
                   |
                   v
                GitHub
                   |
                   v
                Argo CD
                   |
                   v
              Amazon EKS
                   |
                   v
        Kubernetes Application