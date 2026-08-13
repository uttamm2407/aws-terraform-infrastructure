AWS Terraform Infrastructure Automation 🚀

An end-to-end Infrastructure as Code project that provisions AWS
infrastructure using Terraform and automatically validates it using
GitHub Actions.

📌 Table of Contents

Project Overview

Project Objectives

Architecture

Technologies Used

AWS Resources

Project Structure

Terraform Module

Remote State

GitHub Actions CI

Security

Prerequisites

Installation & Setup

Terraform Commands

Verification

Troubleshooting

Screenshots

Resume Highlights

Future Improvements

Author

📌 Project Overview

This project demonstrates how to build and manage AWS cloud
infrastructure using Terraform Infrastructure as Code (IaC).

Instead of manually creating AWS resources from the AWS Console, the
complete infrastructure is defined using Terraform configuration files
and managed through Git.

The project also includes a GitHub Actions CI pipeline that
automatically checks the Terraform configuration whenever changes are
pushed to the repository.

What this project demonstrates

Infrastructure as Code with Terraform

AWS networking

EC2 provisioning

IAM roles and permissions

S3 remote Terraform state

Terraform modules

Git and GitHub version control

GitHub Actions CI

Automated Terraform validation and planning

Linux/Nginx server configuration

🎯 Project Objectives

The main objectives of this project are:

Provision AWS infrastructure using Terraform.

Create a reusable Terraform VPC module.

Store Terraform state remotely using Amazon S3.

Deploy an Ubuntu EC2 web server.

Configure Nginx automatically using EC2 user data.

Configure IAM permissions for AWS resources.

Store the Terraform project in GitHub.

Build an automated Terraform CI pipeline using GitHub Actions.

Validate and plan infrastructure changes automatically.

🏗️ Architecture

                           GitHub Repository
                                  │
                                  │ Push / Pull Request
                                  ▼
                       ┌──────────────────────┐
                       │    GitHub Actions    │
                       │     Terraform CI     │
                       └──────────┬───────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
              Terraform Init   Format Check   Validate
                    │
                    ▼
              Terraform Plan
                    │
                    ▼
              ┌─────────────── AWS ───────────────┐
              │                                   │
              │              VPC                  │
              │               │                   │
              │        ┌──────┴──────┐            │
              │        │Public Subnet│            │
              │        └──────┬──────┘            │
              │               │                   │
              │            EC2 Server             │
              │               │                   │
              │             Nginx                  │
              │                                   │
              │  Internet Gateway                 │
              │  Route Table                      │
              │  Security Group                   │
              │  Elastic IP                       │
              │  IAM Role                         │
              │                                   │
              │  S3 ──► Terraform Remote State   │
              └───────────────────────────────────┘

🛠️ Technologies Used

Technology            Purpose

AWS               Cloud infrastructure
Terraform         Infrastructure as Code
HCL               Terraform configuration language
Amazon EC2        Web server
Amazon VPC        Network infrastructure
Amazon S3         Terraform remote state
AWS IAM           Identity and permissions
Security Groups   Network access control
Elastic IP        Static public IP
Ubuntu            EC2 operating system
Nginx             Web server
Git               Version control
GitHub            Source code repository
GitHub Actions    Continuous Integration

☁️ AWS Resources

1. Amazon VPC

A custom VPC is created for the project.

It contains:

VPC

Public subnet

Internet Gateway

Public route table

Route table association

The VPC configuration is organized into a reusable Terraform module.

2. Public Subnet

The EC2 web server is deployed inside the public subnet.

The subnet has a route to the Internet Gateway, allowing internet
connectivity.

3. Internet Gateway

The Internet Gateway provides internet connectivity between the VPC and
the public internet.

4. Route Table

A public route table is configured with a route to:

0.0.0.0/0

through the Internet Gateway.

5. Security Group

The EC2 security group controls network access to the web server.

Required application/administration ports are configured according to
the project requirements.

6. EC2 Instance

An Ubuntu EC2 instance is provisioned using Terraform.

The instance uses:

Ubuntu AMI

Configurable instance type

Public subnet

Security group

IAM instance profile

Elastic IP

Nginx is automatically installed during instance initialization.

apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx

7. Elastic IP

An Elastic IP is associated with the EC2 instance to provide a stable
public IP address.

8. IAM

The project creates:

IAM role

IAM instance profile

IAM policy

The EC2 instance uses the IAM instance profile instead of requiring AWS
credentials directly inside the server.

9. Amazon S3

Amazon S3 is used as the Terraform remote backend.

This allows Terraform state to be stored remotely instead of relying
only on the local machine.

📂 Project Structure

aws-terraform-infrastructure/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── backend.tf
├── ec2.tf
├── iam.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── s3.tf
├── security-group.tf
├── variables.tf
├── vpc.tf
├── .gitignore
└── .terraform.lock.hcl

File responsibilities

File                                Purpose

provider.tf                       AWS provider configuration
variables.tf                      Project variables
main.tf                           Root Terraform configuration
vpc.tf                            VPC module usage
ec2.tf                            EC2, key configuration and Elastic IP
iam.tf                            IAM role and permissions
s3.tf                             S3 resources
security-group.tf                 EC2 security group
outputs.tf                        Terraform outputs
backend.tf                        Remote Terraform state
modules/vpc/                      Reusable VPC module
.github/workflows/terraform.yml   GitHub Actions CI

Terraform state files and sensitive credentials should not be
committed to GitHub.

🧩 Terraform Module

The VPC infrastructure is separated into a reusable module:

modules/vpc/
├── main.tf
├── variables.tf
└── outputs.tf

The root configuration calls the module.

This improves:

Reusability

Maintainability

Organization

Separation of infrastructure components

🗄️ Remote State

Terraform state is stored remotely using an Amazon S3 backend.

Example:

terraform {
  backend "s3" {
    bucket = "YOUR-TERRAFORM-STATE-BUCKET"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

The real bucket name should not be exposed unnecessarily in
documentation.

The local Terraform state was successfully migrated to the S3 backend.

⚙️ GitHub Actions CI

The project contains:

.github/workflows/terraform.yml

The workflow runs automatically when changes are pushed to main or
when a pull request targets main.

CI Pipeline

Git Push / Pull Request
          │
          ▼
     Checkout Code
          │
          ▼
    Setup Terraform
          │
          ▼
   Verify AWS Secrets
          │
          ▼
 Configure AWS Credentials
          │
          ▼
  Check AWS Identity
          │
          ▼
    Terraform Init
          │
          ▼
 Terraform Format Check
          │
          ▼
 Terraform Validate
          │
          ▼
    Terraform Plan

Commands executed by CI

terraform init
terraform fmt -check -recursive
terraform validate
terraform plan

AWS identity is also checked using:

aws sts get-caller-identity

Final CI Status

The final GitHub Actions workflow completed successfully:

Terraform CI #5
✅ Success

Earlier failed workflow runs are historical troubleshooting attempts;
the final workflow is passing.

🔐 Security

AWS credentials for GitHub Actions are stored as GitHub Repository
Secrets.

The workflow uses:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

They are referenced through:

${{ secrets.AWS_ACCESS_KEY_ID }}
${{ secrets.AWS_SECRET_ACCESS_KEY }}

Important security practices

❌ Never commit AWS access keys.

❌ Never commit AWS secret access keys.

❌ Never commit private SSH keys.

❌ Never commit Terraform state files containing sensitive
information.

✅ Use GitHub Secrets for CI credentials.

✅ Use least-privilege IAM permissions.

✅ Rotate credentials when required.

Recommended production improvement

For a production environment, GitHub Actions can use AWS IAM OIDC
instead of long-lived AWS access keys.

📋 Prerequisites

Before running this project, install:

AWS CLI

Terraform

Git

An AWS account

Appropriate AWS permissions

Check the installations:

terraform version
aws --version
git --version

🚀 Installation & Setup

Step 1 --- Clone the Repository

git clone https://github.com/uttamm2407/aws-terraform-infrastructure.git

Enter the project:

cd aws-terraform-infrastructure

Step 2 --- Configure AWS CLI

aws configure

Enter:

AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1

Verify the credentials:

aws sts get-caller-identity

Step 3 --- Initialize Terraform

terraform init

Terraform will initialize:

AWS provider

VPC module

S3 backend

Terraform state

Step 4 --- Format Terraform

terraform fmt -recursive

Step 5 --- Validate Terraform

terraform validate

Expected:

Success! The configuration is valid.

Step 6 --- Review the Plan

terraform plan

Always review the plan before applying changes.

Step 7 --- Apply Infrastructure

Only after reviewing the plan:

terraform apply

Terraform will provision the configured AWS infrastructure.

🧪 Verification

The project was verified locally using:

terraform plan

Final result:

No changes. Your infrastructure matches the configuration.

This confirms that the Terraform configuration matches the existing AWS
infrastructure.

The GitHub Actions CI pipeline also successfully completed:

✅ Verify AWS Secrets
✅ Configure AWS Credentials
✅ Check AWS Identity
✅ Terraform Init
✅ Terraform Format Check
✅ Terraform Validate
✅ Terraform Plan

🧹 Destroy Infrastructure

If the infrastructure is no longer required:

terraform destroy

⚠️ Use this carefully. It can permanently delete AWS resources
managed by Terraform.

🛠️ Troubleshooting

Terraform credentials error

If you see:

InvalidClientTokenId

check:

aws configure list

Then test:

aws sts get-caller-identity

Terraform plan wants to destroy an unexpected resource

Run:

terraform plan

Read the exact resource Terraform wants to destroy before running:

terraform apply

Never blindly apply a destructive plan.

GitHub Actions says AWS credentials are missing

Verify the repository secrets exist:

Settings
→ Secrets and variables
→ Actions

The workflow expects:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

Terraform state/backend problems

Reinitialize the backend:

terraform init -reconfigure

If Terraform asks to migrate existing state, carefully review the prompt
before accepting.

Terraform formatting error

Run:

terraform fmt -recursive

Then check:

terraform fmt -check -recursive

📸 Screenshots

Recommended screenshots for the GitHub repository:

AWS Infrastructure

EC2 instance

VPC

Security Group

Elastic IP

Terraform

terraform plan

terraform validate

Terraform module structure

GitHub Actions

Successful Terraform CI workflow

Example documentation structure:

docs/
├── aws-ec2.png
├── aws-vpc.png
├── terraform-plan.png
└── github-actions-success.png

💼 Resume Highlights

AWS Terraform Infrastructure Automation

Technologies: AWS, Terraform, GitHub Actions, EC2, VPC, S3, IAM,
Linux, Nginx

Provisioned AWS infrastructure including VPC, public subnet,
Internet Gateway, route table, EC2, Security Group, Elastic IP, IAM
and S3 using Terraform.

Implemented a reusable Terraform VPC module and configured Amazon S3
as a remote Terraform state backend.

Built a GitHub Actions CI pipeline to automatically execute
Terraform initialization, formatting, validation and planning.

Configured AWS credentials securely using GitHub Secrets and
verified AWS identity during CI execution.

Automated Nginx installation on an Ubuntu EC2 instance using
Terraform user data.

📈 Skills Demonstrated

This project demonstrates practical experience with:

☁️ AWS Cloud

🏗️ Infrastructure as Code

🔧 Terraform

📦 Terraform Modules

🗄️ Terraform Remote State

🌐 VPC Networking

💻 EC2

🔐 IAM

🪣 S3

🛡️ Security Groups

📡 Elastic IP

🐧 Linux

🌐 Nginx

🔄 Git

🐙 GitHub

⚙️ GitHub Actions

🔁 Continuous Integration

🔮 Future Improvements

Possible production-level improvements:

Replace long-lived AWS access keys with GitHub Actions OIDC.

Add Terraform security scanning using Checkov or tfsec.

Add Terraform linting.

Add separate development and production environments.

Add protected Terraform apply workflow.

Add CloudWatch monitoring and alarms.

Add Application Load Balancer.

Add Auto Scaling Group.

Add approval gates before production deployment.

👨‍💻 Author

Uttam Pal

GitHub:
https://github.com/uttamm2407

Project Repository:
https://github.com/uttamm2407/aws-terraform-infrastructure

⭐ Project Status

Status: Completed ✅

This project demonstrates an end-to-end AWS Infrastructure as Code
workflow using Terraform, Terraform modules, S3 remote state, IAM, EC2
and GitHub Actions CI.

The final Terraform configuration matches the deployed infrastructure
and the final GitHub Actions Terraform CI workflow passes successfully.
