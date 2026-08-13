# AWS Terraform Infrastructure Automation

Terraform project for provisioning AWS infrastructure using Infrastructure as Code and validating the configuration through GitHub Actions.

## Table of Contents

- Project Overview
- Objectives
- Architecture
- Technologies Used
- AWS Resources
- Project Structure
- Terraform Module
- Remote State
- GitHub Actions CI
- Security
- Prerequisites
- Installation and Setup
- Terraform Commands
- Verification
- Troubleshooting
- Screenshots
- Resume Highlights
- Future Improvements
- Author

## Project Overview

This project demonstrates how to build and manage AWS cloud infrastructure using Terraform.

Instead of manually creating AWS resources through the AWS Management Console, the infrastructure is defined as Terraform configuration files and managed through Git and GitHub.

The project also includes a GitHub Actions CI pipeline that automatically checks the Terraform configuration whenever changes are pushed to the repository.

### Main Features

- Infrastructure as Code using Terraform
- AWS VPC networking
- EC2 web server deployment
- IAM roles and permissions
- S3 remote Terraform state
- Reusable Terraform VPC module
- Git and GitHub version control
- GitHub Actions CI
- Automated Terraform formatting, validation and planning
- Automatic Nginx installation on Ubuntu

## Objectives

The main objectives of this project are:

1. Provision AWS infrastructure using Terraform.
2. Create a reusable Terraform VPC module.
3. Store Terraform state remotely using Amazon S3.
4. Deploy an Ubuntu EC2 web server.
5. Configure Nginx automatically using EC2 user data.
6. Configure IAM roles and permissions.
7. Manage the project using Git and GitHub.
8. Build a GitHub Actions CI pipeline.
9. Automatically validate Terraform changes before deployment.

## Architecture

```text
                         GitHub Repository
                                |
                                | Push / Pull Request
                                v
                    +------------------------+
                    |     GitHub Actions      |
                    |      Terraform CI      |
                    +-----------+------------+
                                |
                +---------------+---------------+
                |               |               |
                v               v               v
         Terraform Init   Format Check     Validate
                |
                v
         Terraform Plan
                |
                v
        +--------------- AWS ----------------+
        |                                    |
        |              VPC                   |
        |               |                    |
        |        +------+-------+            |
        |        | Public Subnet|            |
        |        +------+-------+            |
        |               |                    |
        |            EC2 Server              |
        |               |                    |
        |             Nginx                  |
        |                                    |
        | Internet Gateway                   |
        | Route Table                        |
        | Security Group                     |
        | Elastic IP                         |
        | IAM Role                           |
        |                                    |
        | S3 -> Terraform Remote State       |
        +------------------------------------+
```

## Technologies Used

| Technology | Purpose |
|---|---|
| AWS | Cloud infrastructure |
| Terraform | Infrastructure as Code |
| HCL | Terraform configuration language |
| Amazon EC2 | Web server |
| Amazon VPC | Network infrastructure |
| Amazon S3 | Terraform remote state |
| AWS IAM | Identity and permissions |
| Security Groups | Network access control |
| Elastic IP | Static public IP |
| Ubuntu | EC2 operating system |
| Nginx | Web server |
| Git | Version control |
| GitHub | Source code repository |
| GitHub Actions | Continuous Integration |

## AWS Resources

### 1. VPC

A custom VPC is created for the project.

The VPC contains:

- VPC
- Public subnet
- Internet Gateway
- Public route table
- Route table association

The VPC configuration is organized into a reusable Terraform module.

### 2. Public Subnet

The EC2 web server is deployed inside the public subnet.

The subnet has a route to the Internet Gateway for internet connectivity.

### 3. Internet Gateway

The Internet Gateway provides internet connectivity between the VPC and the public internet.

### 4. Route Table

A public route table is configured with a route to:

```text
0.0.0.0/0
```

through the Internet Gateway.

### 5. Security Group

The EC2 security group controls network access to the web server.

Required ports are configured according to the project requirements.

### 6. EC2 Instance

An Ubuntu EC2 instance is provisioned using Terraform.

The instance uses:

- Ubuntu AMI
- Configurable instance type
- Public subnet
- Security group
- IAM instance profile
- Elastic IP

Nginx is automatically installed during instance initialization:

```bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
```

### 7. Elastic IP

An Elastic IP is associated with the EC2 instance to provide a stable public IP address.

### 8. IAM

The project creates:

- IAM role
- IAM instance profile
- IAM policy

The EC2 instance uses the IAM instance profile for AWS resource access.

### 9. Amazon S3

Amazon S3 is used as the Terraform remote backend.

This allows Terraform state to be stored remotely rather than only on the local machine.

## Project Structure

```text
aws-terraform-infrastructure/
|
+-- .github/
|   +-- workflows/
|       +-- terraform.yml
|
+-- modules/
|   +-- vpc/
|       +-- main.tf
|       +-- variables.tf
|       +-- outputs.tf
|
+-- backend.tf
+-- ec2.tf
+-- iam.tf
+-- main.tf
+-- outputs.tf
+-- provider.tf
+-- s3.tf
+-- security-group.tf
+-- variables.tf
+-- vpc.tf
+-- .gitignore
+-- .terraform.lock.hcl
+-- README.md
```

### File Responsibilities

| File | Purpose |
|---|---|
| provider.tf | AWS provider configuration |
| variables.tf | Project variables |
| main.tf | Root Terraform configuration |
| vpc.tf | VPC module usage |
| ec2.tf | EC2 and Elastic IP configuration |
| iam.tf | IAM role and permissions |
| s3.tf | S3 resources |
| security-group.tf | EC2 security group |
| outputs.tf | Terraform outputs |
| backend.tf | Remote Terraform state |
| modules/vpc/ | Reusable VPC module |
| .github/workflows/terraform.yml | GitHub Actions CI |

Terraform state files, credentials and private keys should not be committed to GitHub.

## Terraform Module

The VPC infrastructure is separated into a reusable module:

```text
modules/vpc/
|
+-- main.tf
+-- variables.tf
+-- outputs.tf
```

The root Terraform configuration calls this module.

Using a module improves:

- Reusability
- Maintainability
- Organization
- Separation of infrastructure components

## Remote State

Terraform state is stored remotely using an Amazon S3 backend.

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "YOUR-TERRAFORM-STATE-BUCKET"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
```

The actual bucket name should not be unnecessarily exposed in documentation.

The existing local Terraform state was successfully migrated to the S3 backend.

## GitHub Actions CI

The project contains:

```text
.github/workflows/terraform.yml
```

The workflow runs automatically when changes are pushed to the main branch or when a pull request targets the main branch.

### CI Pipeline

```text
Git Push / Pull Request
          |
          v
     Checkout Code
          |
          v
    Setup Terraform
          |
          v
   Verify AWS Secrets
          |
          v
 Configure AWS Credentials
          |
          v
  Check AWS Identity
          |
          v
    Terraform Init
          |
          v
 Terraform Format Check
          |
          v
 Terraform Validate
          |
          v
    Terraform Plan
```

### Terraform Commands Used by CI

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

AWS identity is checked using:

```bash
aws sts get-caller-identity
```

### Final CI Result

The final GitHub Actions workflow completed successfully.

The final pipeline successfully performed:

- AWS credential verification
- AWS identity verification
- Terraform initialization
- Terraform formatting check
- Terraform validation
- Terraform planning

Earlier failed workflow runs are historical troubleshooting attempts. The final workflow run is successful.

## Security

AWS credentials used by GitHub Actions are stored as GitHub Repository Secrets.

The workflow references:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

They are accessed through:

```yaml
${{ secrets.AWS_ACCESS_KEY_ID }}
${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### Security Practices

- Do not commit AWS access keys.
- Do not commit AWS secret access keys.
- Do not commit private SSH keys.
- Do not commit Terraform state files containing sensitive information.
- Use GitHub Secrets for CI credentials.
- Use least-privilege IAM permissions.
- Rotate credentials when required.

For production environments, GitHub Actions OIDC with AWS IAM roles is recommended instead of long-lived access keys.

## Prerequisites

Before running the project, install:

- AWS CLI
- Terraform
- Git
- An AWS account with appropriate permissions

Check the installations:

```bash
terraform version
aws --version
git --version
```

## Installation and Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/uttamm2407/aws-terraform-infrastructure.git
```

Enter the project directory:

```bash
cd aws-terraform-infrastructure
```

### Step 2: Configure AWS CLI

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1
```

Verify the credentials:

```bash
aws sts get-caller-identity
```

### Step 3: Initialize Terraform

```bash
terraform init
```

Terraform initializes:

- AWS provider
- VPC module
- S3 backend
- Terraform state

### Step 4: Format Terraform

```bash
terraform fmt -recursive
```

### Step 5: Validate Terraform

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

### Step 6: Review the Plan

```bash
terraform plan
```

Always review the plan before applying changes.

### Step 7: Apply Infrastructure

Only after reviewing the plan:

```bash
terraform apply
```

## Terraform Commands

### Initialize

```bash
terraform init
```

### Format

```bash
terraform fmt -recursive
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Show State

```bash
terraform state list
```

### Destroy

```bash
terraform destroy
```

Use destroy carefully because it can permanently remove AWS resources managed by Terraform.

## Verification

The final Terraform configuration was verified locally using:

```bash
terraform plan
```

Final result:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms that the Terraform configuration matches the deployed AWS infrastructure.

The GitHub Actions CI workflow also completed successfully.

Final CI checks:

```text
Verify AWS Secrets
Configure AWS Credentials
Check AWS Identity
Terraform Init
Terraform Format Check
Terraform Validate
Terraform Plan
```

## Troubleshooting

### Terraform credentials error

If you see:

```text
InvalidClientTokenId
```

check:

```bash
aws configure list
```

Then test:

```bash
aws sts get-caller-identity
```

### Terraform plan wants to destroy an unexpected resource

Run:

```bash
terraform plan
```

Read the exact resource Terraform wants to destroy before running:

```bash
terraform apply
```

Do not blindly apply a destructive plan.

### GitHub Actions says AWS credentials are missing

Check:

```text
GitHub Repository
    -> Settings
    -> Secrets and variables
    -> Actions
```

The workflow expects:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

### Terraform backend problems

Reinitialize the backend with:

```bash
terraform init -reconfigure
```

If Terraform asks to migrate existing state, carefully review the prompt before accepting.

### Terraform formatting error

Run:

```bash
terraform fmt -recursive
```

Then check:

```bash
terraform fmt -check -recursive
```

## Screenshots

Recommended screenshots for the repository:

### AWS

- EC2 instance
- VPC
- Security Group
- Elastic IP

### Terraform

- Terraform plan
- Terraform validate
- Terraform module structure

### GitHub Actions

- Successful Terraform CI workflow

Suggested documentation folder:

```text
docs/
|
+-- aws-ec2.png
+-- aws-vpc.png
+-- terraform-plan.png
+-- github-actions-success.png
```


## Skills Demonstrated

This project demonstrates practical experience with:

- AWS Cloud
- Infrastructure as Code
- Terraform
- Terraform Modules
- Terraform Remote State
- VPC Networking
- EC2
- IAM
- S3
- Security Groups
- Elastic IP
- Linux
- Nginx
- Git
- GitHub
- GitHub Actions
- Continuous Integration


## Author

Uttam Pal

GitHub:

https://github.com/uttamm2407

Project Repository:

https://github.com/uttamm2407/aws-terraform-infrastructure

