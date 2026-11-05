🌍 Wanderlust – DevOps Automation & GitOps Deployment

<p align="center">
  <b>A complete DevOps implementation for deploying the Wanderlust MERN application on AWS EKS.</b>
  <br/>
  <i>Terraform • Ansible • Jenkins • Docker • Kubernetes • Argo CD</i>
</p>---

🏗️ Architecture Diagram

"Wanderlust DevOps Architecture" (assets/Architecture_Diagram)

---

📌 Project Overview

The original Wanderlust Mega Project application was created by "Shubham Londhe" (https://github.com/LondheShubham153). I used the original project as a reference and rebuilt its deployment and DevOps workflow in my own repository. My goal was to go beyond following a deployment walkthrough and build a more automated, repeatable, and GitOps-based delivery process. I focused on automating AWS infrastructure provisioning and server configuration, improving Docker image efficiency, integrating security and code-quality checks into Jenkins, and using Argo CD to manage application deployment on Amazon EKS.

Project| Repository
🎯 Original application| "Wanderlust Mega Project" (https://github.com/LondheShubham153/Wanderlust-Mega-Project)
🚀 My implementation| "wanderlust-devops-automation" (https://github.com/snehalpawar29/wanderlust-devops-automation)

---

☁️ 1. Infrastructure Automation – Terraform & Ansible

I automated AWS infrastructure provisioning and server configuration using Terraform and Ansible, replacing the original workflow's manual infrastructure and tool-setup steps with reusable automation.

✨ What I improved

- 🏗️ Used Terraform to provision the VPC, subnets across two Availability Zones, NAT Gateway, security groups, EC2 instances, IAM roles, and Amazon EKS resources.
- ⚙️ Used Ansible to configure the Jenkins master and worker, installing and configuring the required DevOps tools.
- 🐳 Automated the installation of Docker, Jenkins, AWS CLI, kubectl, eksctl, Kind, SonarQube, and Trivy through Ansible playbooks.
- ☸️ Automated EKS kubeconfig configuration and Argo CD installation.
- 🔧 Separated infrastructure provisioning from server configuration to keep the workflow modular and maintainable.

📊 Recorded Setup-Time Comparison

Workflow| Recorded Time
🛠️ Original manual setup workflow| 33 minutes
⚡ Terraform + Ansible automation| 11 minutes

<p align="center">📉 66.7% Lower Recorded Setup Time</p>

"Infrastructure Setup Time Comparison" (Assets/infrastructure-setup-comparison.png)

The percentage represents the calculated difference between the two recorded setup times.

---

🐳 2. Docker Image Optimization

I reviewed and improved the frontend and backend Dockerfiles using multi-stage builds and more focused runtime images.

✨ What I improved

🎨 Frontend

- Used a multi-stage Docker build with Node.js 22 Alpine.
- Installed dependencies using "npm ci".
- Built the frontend application and copied only the generated "dist/" directory into the final Nginx Alpine image.
- Kept build-time dependencies out of the final runtime image.

⚙️ Backend

- Used a multi-stage Docker build with Node.js 22 Slim.
- Installed dependencies using "npm ci".
- Used "npm ci --omit=dev" in the production stage.
- Copied only the required application files into the final image.

📊 Docker Image-Size Comparison

Application| Original Image| Optimized Image| Reduction
🎨 Frontend| 718 MB| 94.9 MB| 86.8%
⚙️ Backend| 427 MB| 368 MB| 13.8%

"Docker Image Size Comparison" (Assets/docker-image-size-comparison.png)

🎯 Result: Smaller Docker images with reduced runtime image contents and more efficient image distribution.

---

🔄 3. CI Pipeline – Jenkins

I implemented a Jenkins pipeline integrated with a reusable Jenkins Shared Library to automate application validation, image creation, and publishing.

✨ What I improved

- 📦 Integrated a Jenkins Shared Library to reuse pipeline functions.
- 🔍 Added GitHub source-code checkout.
- 🛡️ Integrated Trivy filesystem scanning.
- 🔐 Integrated OWASP Dependency-Check for dependency vulnerability analysis.
- 📊 Integrated SonarQube code analysis and quality-gate validation.
- ⚡ Built frontend and backend Docker images in parallel.
- 🚀 Pushed the generated images to Docker Hub.
- 🔁 Automated Kubernetes manifest image-tag updates and pushed the updated manifests to GitHub.
- 📧 Added email notifications and workspace cleanup.

This creates a structured CI workflow that combines security checks, code-quality analysis, and parallel image-building stages.

---

🚀 4. GitOps Deployment – Argo CD & Kubernetes

I integrated Argo CD with Amazon EKS to implement GitOps-based application deployment.

✨ What I improved

- ☸️ Installed and configured Argo CD on the EKS cluster.
- 🔗 Connected Argo CD to the GitHub repository containing Kubernetes manifests.
- 📁 Configured Git as the desired-state source for application deployment.
- 🔄 Used Argo CD to synchronize Kubernetes manifests with the EKS cluster.
- 📦 Organized application resources in the "wanderlust-ns" namespace.

☸️ Kubernetes Resources

Component| Configuration
🎨 Frontend| Deployment with 2 replicas and NodePort Service
⚙️ Backend| Deployment with 2 replicas and ClusterIP Service
🔴 Redis| Deployment and Service
🍃 MongoDB| StatefulSet with persistent storage
💾 Storage| Persistent Volume and Persistent Volume Claim

Argo CD continuously monitors the configured Git repository and helps keep the Kubernetes environment aligned with the declared manifests.

📈 Monitoring – Prometheus & Grafana

Prometheus and Grafana are part of the monitoring stack in the original project reference. They are not currently provisioned by the automation in this repository, so I have not included them as completed implementation features.

They are planned as a future extension to provide cluster and application metrics, dashboards, and monitoring visibility.

---

⏱️ 5. Deployment Elapsed-Time Comparison

The recorded manual workflow took 16 minutes 22 seconds, while the Jenkins + Argo CD workflow was recorded at 4 minutes 49 seconds.

"Deployment Elapsed-Time Comparison" (Assets/deployment-time-comparison.png)

📉 70.6% Lower Recorded Elapsed Time

16:22 Manual Workflow → 04:49 Jenkins + Argo CD Workflow

✨ What I improved

- ⚙️ Jenkins automates validation, parallel frontend/backend image builds and pushes, and Kubernetes manifest updates in GitHub.
- 🔄 Argo CD monitors the Git repository and synchronizes the desired manifests to Amazon EKS.
- 🚀 Connected CI and GitOps into a streamlined application delivery workflow.

The percentage represents the calculated difference between the two recorded elapsed times (982 seconds and 289 seconds).

---

🧰 Technology Stack

Category| Tools & Technologies
☁️ Cloud| AWS – VPC, EC2, IAM, EKS, ECR, S3
🏗️ Infrastructure as Code| Terraform
⚙️ Configuration Management| Ansible
🔄 CI/CD| Jenkins, Jenkins Shared Library
🐳 Containerization| Docker
☸️ Container Orchestration| Kubernetes, Amazon EKS
🚀 GitOps| Argo CD
🛡️ Security Scanning| Trivy, OWASP Dependency-Check
📊 Code Quality| SonarQube
💻 Application Stack| React, Node.js, Express, MongoDB, Redis
🌐 Web Server| Nginx
🔗 Version Control| Git, GitHub
📦 Container Registry| Docker Hub

---

📂 Repository Structure

wanderlust-devops-automation/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
│
├── ansible/
│   ├── master_setup.yml
│   ├── jenkins_worker_setup.yml
│   └── ...
│
├── Jenkinsfile
│
├── kubernetes/
│   ├── frontend/
│   ├── backend/
│   ├── redis/
│   └── mongodb/
│
├── Dockerfile
│
├── assets/
│   └── Architecture_Diagram
│
└── README.md

The structure above highlights the main project areas; individual files and folders may vary in the repository.

---

🔐 Security Notes

- 🔑 Use IAM roles with least-privilege permissions for AWS resources.
- 🔒 Store application credentials and sensitive values outside version control.
- 🛡️ Use Kubernetes Secrets or an external secrets-management solution for sensitive application configuration.
- 🔍 Review security-group ingress rules and IAM policies before deploying in a production environment.

---

🎯 Key Outcomes

- ✅ Automated AWS infrastructure provisioning using Terraform.
- ✅ Automated server and DevOps tool configuration using Ansible.
- 📉 Reduced recorded infrastructure setup time by 66.7%.
- 🐳 Reduced frontend Docker image size by 86.8% and backend image size by 13.8%.
- 🛡️ Integrated security scanning and code-quality checks into Jenkins.
- ⚡ Automated parallel Docker image builds and publishing.
- 🚀 Implemented GitOps-based deployment using Argo CD and Amazon EKS.
- ⏱️ Recorded a 70.6% lower elapsed time for the Jenkins + Argo CD workflow compared with the recorded manual workflow.

---

🙏 Credits

- Original application and reference project: "Shubham Londhe – Wanderlust Mega Project" (https://github.com/LondheShubham153/Wanderlust-Mega-Project)
- DevOps automation and deployment implementation: [Snehal Pawar](https://github.com/snehalpaw ar29)

---

👨‍💻 Author

Snehal Pawar

Cloud & DevOps Engineer | AWS | Kubernetes | CI/CD | Automation

<p>
  <a href="https://github.com/snehalpaw ar29">GitHub</a> •
  <a href="https://linkedin.com/in/snehalpaw ar29">LinkedIn</a> •
  <a href="https://snehalpaw ar29.github.io/Snehal-Pawar-Devops-Portfolio/">Portfolio</a>
</p>⭐ If you find this project useful, consider giving the repository a star!
