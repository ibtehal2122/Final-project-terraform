# Production-Grade EKS Cluster on AWS with Terraform, Ansible, and GitOps

## Introduction

This project provides a comprehensive and production-ready solution for deploying and managing a secure, scalable, and highly available EKS (Elastic Kubernetes Service) cluster on AWS. It leverages a modern GitOps approach, using Terraform for infrastructure as code, Ansible for configuration management, and GitHub Actions for CI/CD.

This document serves as a complete guide for understanding, deploying, and managing this infrastructure. It is intended for DevOps engineers, cloud architects, and anyone interested in building and maintaining production-grade Kubernetes environments on AWS.

## Architecture

The architecture is designed to be secure, resilient, and cost-effective, following the AWS Well-Architected Framework.

### High-Level Diagram

```
+-----------------+      +----------------------+      +--------------------+
|   GitHub Repo   |----->|  GitHub Actions CI/CD  |----->|   GitOps Repo      |
| (App & Infra Code)|      | (Terraform & Ansible)  |      | (Kubernetes Manifests) |
+-----------------+      +----------------------+      +--------------------+
        ^                                                     |
        |                                                     v
        |                                             +-----------------+
        |                                             |   ArgoCD        |
        |                                             | (In EKS Cluster)|
        |                                             +-----------------+
        |                                                     |
        +-----------------------------------------------------+
                                      |
                                      v
                          +-------------------------+
                          |      AWS Cloud          |
                          |-------------------------|
                          |  +-------------------+  |
                          |  |    VPC            |  |
                          |  |-------------------|  |
                          |  | +-------+ +-------+ |  |
                          |  | | Public| | Private| |  |
                          |  | | Subnet| | Subnet | |  |
                          |  | +-------+ +-------+ |  |
                          |  |    |         |      |  |
                          |  |  NAT GW     EKS     |  |
                          |  |    |       Cluster  |  |
                          |  |    +---------+      |  |
                          |  +-------------------+  |
                          +-------------------------+
```

### Components

*   **AWS Cloud:** The foundation of our infrastructure, providing the necessary services like VPC, EKS, ECR, IAM, and S3.
*   **VPC:** A logically isolated section of the AWS Cloud where we launch our resources. It is configured with public and private subnets across multiple availability zones for high availability.
*   **EKS Cluster:** A managed Kubernetes service that makes it easy to run Kubernetes on AWS without needing to install and operate your own Kubernetes control plane. The cluster is deployed in the private subnets for security.
*   **ECR (Elastic Container Registry):** A fully-managed Docker container registry that makes it easy for developers to store, manage, and deploy Docker container images.
*   **GitHub:** The source code repository for our application and infrastructure code.
*   **GitHub Actions:** The CI/CD platform that automates the process of building, testing, and deploying our infrastructure and applications.
*   **GitOps Repository:** A separate GitHub repository that stores the desired state of our Kubernetes cluster in the form of YAML manifests.
*   **ArgoCD:** A declarative, GitOps continuous delivery tool for Kubernetes. It continuously monitors the GitOps repository and applies the changes to the EKS cluster.
*   **Terraform:** An open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.
*   **Ansible:** An open-source software provisioning, configuration management, and application-deployment tool.

## Technology Stack

| Technology | Purpose | Justification |
| --- | --- | --- |
| **AWS** | Cloud Provider | A mature and feature-rich cloud platform with a wide range of services for building and running modern applications. |
| **Terraform** | Infrastructure as Code | A popular and powerful tool for managing infrastructure as code. It allows us to define our infrastructure in a declarative way and manage its lifecycle. |
| **Ansible** | Configuration Management | A simple yet powerful tool for automating the configuration of our EKS cluster. We use it to install and configure tools like ArgoCD, Prometheus, and Kyverno. |
| **Kubernetes (EKS)** | Container Orchestration | The de-facto standard for container orchestration. EKS provides a managed and scalable Kubernetes control plane. |
| **Docker** | Containerization | The most popular containerization platform. |
| **GitHub** | Source Code Management | A popular and widely used platform for hosting Git repositories. |
| **GitHub Actions** | CI/CD | A flexible and powerful CI/CD platform that is tightly integrated with GitHub. |
| **ArgoCD** | GitOps | A popular and easy-to-use GitOps tool for Kubernetes. |
| **Prometheus & Grafana**| Monitoring | A powerful and open-source monitoring and alerting toolkit. |
| **Kyverno** | Policy Management | A policy engine designed for Kubernetes. It allows us to define and enforce policies in our cluster. |

## Repository Structure

```
.
├── ansible
│   ├── group_vars
│   │   └── all.yaml
│   ├── playbook.yaml
│   └── roles
│       ├── argocd
│       ├── kyverno
│       └── monitoring
├── .github
│   └── workflows
│       ├── deploy.yml
│       └── destroy.yml
└── terraform
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── modules
        ├── ec2
        ├── eks
        └── vpc
```

*   **`ansible`:** Contains the Ansible playbooks and roles for configuring the EKS cluster.
*   **`.github/workflows`:** Contains the GitHub Actions workflows for CI/CD.
*   **`terraform`:** Contains the Terraform code for provisioning the AWS infrastructure.

## Prerequisites

Before you can run this project, you will need the following:

*   **AWS Account:** An AWS account with the necessary permissions to create the resources defined in the Terraform code.
*   **GitHub Account:** A GitHub account.
*   **Terraform:** Terraform installed on your local machine.
*   **Ansible:** Ansible installed on your local machine.
*   **AWS CLI:** The AWS CLI installed and configured on your local machine.
*   **kubectl:** The Kubernetes command-line tool installed on your local machine.
*   **Helm:** The Helm package manager for Kubernetes installed on your local machine.

## Step-by-Step Guide

### 1. Configure AWS and GitHub

1.  **Create an IAM Role for GitHub Actions:**
    *   In the AWS IAM console, create a new role for GitHub Actions to assume. This role should have the necessary permissions to create the resources defined in the Terraform code.
    *   Configure the trust relationship for the role to allow GitHub Actions to assume it.
2.  **Create GitHub Secrets:**
    *   In your GitHub repository, create the following secrets:
        *   `AWS_ACCOUNT_ID`: Your AWS account ID.
        *   `GITOPS_REPO_TOKEN`: A personal access token with `repo` scope for your GitOps repository.

### 2. Run the Terraform Code

1.  **Initialize Terraform:**
    ```bash
    cd terraform
    terraform init
    ```
    This command initializes the Terraform working directory, downloading the necessary providers and modules.

2.  **Review the Terraform Plan:**
    ```bash
    terraform plan -out=tfplan
    ```
    This command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

3.  **Apply the Terraform Plan:**
    ```bash
    terraform apply "tfplan"
    ```
    This command applies the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a `terraform plan` execution plan.

### 3. Run the Ansible Code

1.  **Install Ansible Collections:**
    ```bash
    ansible-galaxy collection install kubernetes.core
    ```
    This command installs the `kubernetes.core` collection, which provides the modules for managing Kubernetes resources.

2.  **Run the Ansible Playbook:**
    ```bash
    cd ansible
    ansible-playbook playbook.yaml
    ```
    This command runs the Ansible playbook, which will configure the EKS cluster with ArgoCD, Prometheus, Grafana, and Kyverno.

### 4. Trigger the GitHub Actions Pipelines

1.  **Deploy Pipeline:**
    *   Go to the "Actions" tab in your GitHub repository.
    *   Select the "Production Deployment Pipeline" workflow.
    *   Click the "Run workflow" button.
    This will trigger the deploy pipeline, which will provision the infrastructure and update the GitOps repository.

2.  **Destroy Pipeline:**
    *   Go to the "Actions" tab in your GitHub repository.
    *   Select the "Production Destroy Pipeline" workflow.
    *   Click the "Run workflow" button.
    This will trigger the destroy pipeline, which will destroy the infrastructure.

## CI/CD Pipeline Explained

The CI/CD pipeline is the heart of our automation. Here is a detailed breakdown of what happens when the `deploy` pipeline is triggered:

1.  **Checkout Code:** The pipeline checks out the code from the GitHub repository.
2.  **Configure AWS Credentials:** It configures the AWS credentials using OIDC, which is a secure way to authenticate with AWS from GitHub Actions.
3.  **Terraform Init, Validate, Plan:** It initializes Terraform, validates the code, and creates a plan.
4.  **Manual Approval:** It pauses the pipeline and waits for a manual approval. This is a crucial safety measure to prevent accidental deployments to production.
5.  **Terraform Apply:** After the approval, it applies the Terraform plan and provisions the infrastructure.
6.  **Update GitOps Repository:** It checks out the GitOps repository, updates the application version, and pushes the changes.
7.  **ArgoCD Sync:** ArgoCD detects the changes in the GitOps repository and automatically syncs the changes to the EKS cluster.

## Monitoring and Security

*   **Monitoring:** The `kube-prometheus-stack` provides a comprehensive monitoring solution for our EKS cluster. It includes Prometheus for collecting metrics and Grafana for visualizing them.
*   **Security:**
    *   **Private EKS Cluster:** The EKS cluster is deployed in private subnets, which means it is not accessible from the public internet.
    *   **OIDC:** We use OIDC for authenticating with AWS, which is more secure than using static credentials.
    *   **Kyverno:** We use Kyverno to enforce policies in our cluster, such as disallowing the use of the `default` namespace.
    *   **VPC Flow Logs:** VPC flow logs are enabled to capture information about the IP traffic going to and from network interfaces in our VPC.
    *   **ECR Scanning:** ECR image scanning is enabled to automatically scan our container images for vulnerabilities.

## Conclusion

This project provides a solid foundation for building and managing production-grade EKS clusters on AWS. By leveraging the power of Terraform, Ansible, and GitOps, we can automate the entire lifecycle of our infrastructure and applications, from provisioning to deployment and management. The focus on security, high availability, and scalability makes this solution suitable for a wide range of use cases.