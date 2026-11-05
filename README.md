
🌍 Wanderlust — DevSecOps & GitOps Automation
Rebuilding the delivery platform with Infrastructure as Code, CI/CD, security checks and GitOps
� � � � �
� � � � �
My DevOps implementation: snehalpawar29/wanderlust-devops-automation
Original project: LondheShubham153/Wanderlust-Mega-Project

🏗️ Architecture

![Alt Text](assets/Architecture_Diagram.png)

🎯 Project ownership, rebuild motivation and my contribution
The original Wanderlust MERN travel-blog application and its deployment walkthrough are credited to LondheShubham153. I used that project as the application and learning reference, then rebuilt the DevOps and deployment side in my own repository. My goal was to move away from manually creating AWS resources and installing/configuring tools step by step, and create a more repeatable workflow: provision infrastructure with Terraform, configure EC2 and Kubernetes tooling with Ansible, run security and code-quality checks in Jenkins, package optimized Docker images, and deploy Kubernetes changes through GitHub and Argo CD. The original application is credited to its owner; this repository focuses on my infrastructure, automation, containerization, CI/CD and GitOps implementation.
1. ☁️ Terraform + Ansible — Infrastructure and configuration automation
Manual reference workflow vs. my automation
The original guide walks through manual AWS resource creation and installation/configuration steps for the Jenkins master, EKS cluster, node group and worker. I replaced much of that repeatable setup with Terraform resources and Ansible playbooks.
�
Original chart: PNG
66.7% calculated reduction 33 minutes manual → 11 minutes Terraform + Ansible
What I changed:
Terraform: Declared the VPC, subnets across two Availability Zones, NAT gateway, security group, EC2 instances, IAM roles/instance profiles, EKS cluster, managed node group, OIDC provider and EKS access configuration as code.
Ansible: Automated master setup (Docker, Jenkins, AWS CLI, Kind, kubectl, eksctl and SonarQube), worker setup (Docker, AWS CLI and Trivy), EKS kubeconfig configuration and Argo CD installation.
Repeatability: Kept infrastructure definitions and configuration playbooks in the repository instead of relying only on a long sequence of console actions and shell commands.
Timing context: 66.7% is the arithmetic reduction from the recorded 33-minute manual setup and 11-minute automated setup. The manual timing excluded VPC setup, while the current Terraform configuration also creates the VPC. Treat this as an indicative recorded comparison, not a controlled like-for-like benchmark.
2. 🐳 Dockerfiles — Image-size optimization
I redesigned the frontend and backend Dockerfiles to keep build-time dependencies and tools out of the final runtime images.
�
Comparison chart: PNG
Image
Original
My image
Reduction
Frontend
718 MB
94.9 MB
86.8%
Backend
427 MB
368 MB
13.8%
What I changed:
Frontend: Replaced the Node-based development runtime with a multi-stage build using node:22-alpine, npm ci and npm run build; the final stage uses nginx:alpine and serves only the compiled dist/ assets.
Backend: Used node:22-slim multi-stage builds, npm ci, npm ci --omit=dev in the production stage, and copied only the required runtime directories instead of carrying the full build workspace.
Result: The frontend image is 86.8% smaller and the backend image is 13.8% smaller based on the before/after image sizes recorded for this project.
Build-test note: The npm run test command in the current backend Dockerfile is commented out. I am not claiming that the current Docker build runs the backend test suite; a dedicated Jenkins test stage is a useful next improvement.
3. 🔧 Jenkins — Consolidated CI and image-release pipeline
The original reference uses separate Jenkins CI and CD jobs. I brought the main validation, image build/push and Kubernetes manifest-update steps into one Jenkins pipeline using a Jenkins Shared Library and a worker agent labelled Node.
What I changed:
Clean workspace and check out the main branch.
Run Trivy filesystem scanning and OWASP Dependency-Check.
Run SonarQube analysis and wait for the configured quality gate.
Build frontend and backend Docker images in parallel using the Jenkins build number as the image tag.
Push both images to Docker Hub in parallel.
Update the Kubernetes deployment image tags and commit the manifest changes back to GitHub.
Clean the workspace and send success/failure email notifications.
Why it is better: The stages are maintained in a single version-controlled Jenkinsfile; reusable Shared Library functions reduce repeated pipeline code; parallel build and push stages avoid running the frontend and backend image work sequentially; and the manifest commit provides the Git change that Argo CD can reconcile.
4. 🚀 Argo CD, Prometheus and Grafana — GitOps and observability
Argo CD — implemented in this repository
The original guide describes installing and configuring Argo CD through manual commands. I added an Ansible playbook that creates the argocd namespace, applies the Argo CD installation manifest, waits for Argo CD pods to become Ready and verifies the resulting pods.
In the delivery flow, Jenkins commits updated Kubernetes image tags to GitHub. Argo CD uses the Git repository as the desired-state source and synchronizes the manifests to Amazon EKS. This separates image creation and manifest updates (Jenkins) from Kubernetes reconciliation (Argo CD).
Prometheus + Grafana — status of this repository
The original project guide includes a Prometheus/Grafana installation using Helm. In the current version of my repository, I could not verify checked-in Helm values, Ansible tasks or Kubernetes manifests that automate that monitoring stack. I have therefore not described Prometheus/Grafana as an improvement delivered by this repository. They can be added as a follow-up observability layer with version-controlled Helm values and deployment configuration.
5. ⏱️ Deployment elapsed-time comparison
The recorded manual workflow took 16 minutes 22 seconds, while the Jenkins + Argo CD workflow was recorded at 4 minutes 49 seconds.
�
70.6% lower recorded elapsed time — 16:22 manual workflow → 04:49 Jenkins + Argo CD workflow.
What I improved: Jenkins automates validation, parallel frontend/backend image builds and pushes, and Kubernetes manifest updates in GitHub. Argo CD watches the Git repository and synchronizes the desired manifests to Amazon EKS. This connects CI and GitOps into a streamlined application delivery workflow.
The percentage represents the calculated difference between the two recorded elapsed times (982 seconds and 289 seconds).
📌 Technology stack
Area
Tools
Cloud
AWS VPC, EC2, IAM, EKS
Infrastructure as Code
Terraform
Configuration Management
Ansible
CI/CD
Jenkins, Jenkins Shared Library, Groovy
Security and Quality
Trivy, OWASP Dependency-Check, SonarQube Quality Gate
Containers
Docker, Docker Hub, Nginx
Orchestration and GitOps
Kubernetes, Argo CD
Application/Data
React, Node.js, MongoDB, Redis
Source Control
Git, GitHub
📁 Repository structure
.
├── Assets/                 # Comparison charts used in this README
├── Automations/            # Environment update scripts
├── ansible/                # Master, worker, kubeconfig and Argo CD playbooks
├── backend/                # Node.js backend application
├── frontend/               # React/Vite frontend application
├── kubernetes/             # Deployments, Services, StatefulSet and storage manifests
├── terraform/              # AWS VPC, EC2, IAM and EKS resources
├── docker-compose.yml      # Local multi-container setup
├── Jenkinsfile             # Jenkins CI pipeline
└── README.md
🔒 Security note
Before using this repository as a public portfolio example, rotate the JWT signing secret that was previously committed in kubernetes/secrets.yaml, remove the real value from tracked files and Git history, and replace it with a safe template or external secret-management approach. Also review the broad security-group ingress rules and the EC2 roles currently attached to AdministratorAccess before treating this as a production deployment.
🙌 Credits
Original application and deployment reference: LondheShubham153/Wanderlust-Mega-Project
DevOps automation, infrastructure code, Docker improvements and CI/GitOps implementation in this repository: Snehal Pawar
👩‍💻 Author
Snehal Pawar · Cloud & DevOps Engineer
GitHub · LinkedIn

Automate infrastructure. Secure the pipeline. Deploy through GitOps.
