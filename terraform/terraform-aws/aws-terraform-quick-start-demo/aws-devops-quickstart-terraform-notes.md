# AWS DevOps Quick Start – Terraform Edition

This runbook details the initial setup for an AWS practice account for DevOps and IaC (Infrastructure as Code) learning and experimentation, using **Terraform** for automation. Each step below contains the Terraform configuration files, CLI commands, and automation details.

---

## Prerequisites

- You have created a new AWS account (free tier eligible).
- AWS CLI is installed and configured (`aws configure`) with credentials for an admin/root user.
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) is installed.
- [GitHub Actions](https://github.com/aws-actions/) or another CI is available for automation.

---

## 1. Security & Account Hygiene

### 1.1. Create an Admin IAM User and Group

**Terraform file:** `iam-admin.tf`

```hcl
# 1.1. Create an Admin IAM User and Group (Terraform Equivalent)

resource "aws_iam_group" "admin_group" {
  name = "admin-group"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

resource "aws_iam_user" "admin_user" {
  name = "admin-user"
}

resource "aws_iam_user_group_membership" "admin_membership" {
  user = aws_iam_user.admin_user.name
  groups = [aws_iam_group.admin_group.name]
}

resource "aws_iam_access_key" "admin_access_key" {
  user = aws_iam_user.admin_user.name
}

output "admin_user_name" {
  description = "Name of the admin user"
  value       = aws_iam_user.admin_user.name
}

output "admin_access_key_id" {
  description = "Access key ID for the admin user"
  value       = aws_iam_access_key.admin_access_key.id
}

output "admin_secret_access_key" {
  description = "Secret access key for the admin user (visible only at creation!)"
  value       = aws_iam_access_key.admin_access_key.secret
  sensitive   = true
}
```

**Deploy:**

```sh
terraform init
terraform apply
```

**Notes:**
- **Root user MFA** must be enabled manually via the AWS Console (cannot be automated).
- Save the secret access key securely; it's visible only at creation.
- Enable MFA for this IAM user manually after creation (AWS Console or AWS CLI).
- You may want to add an `aws` provider block if not already present (see budget.tf for an example).

---

## 2. Billing & Budget Controls

### 2.1. Create a Monthly Budget Alert

**Terraform file:** `budget.tf`

```hcl
# 2.1. Monthly Budget Alert (Terraform Equivalent)

provider "aws" {
  region = "us-east-1"
}

resource "aws_budgets_budget" "monthly_budget" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = ["your-email@example.com"] # <-- Replace with your email
  }
}
```

**Deploy:**

```sh
terraform apply
```

**Notes:**
- Change `your-email@example.com` to your actual email.
- Some billing/account settings (like enabling Cost Explorer, or changing account contacts) must be done manually in the AWS Console.

---

## 3. Networking Foundations

### 3.1. Basic VPC, Subnets, and Internet Gateway

**Terraform file:** `vpc.tf`

```hcl
# 3.1. Basic VPC, Subnets, and Internet Gateway (Terraform Equivalent)

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
```

**Deploy:**

```sh
terraform apply
```

---

## 4. Automating with GitHub Actions (CI/CD)

**Workflow file:** `.github/workflows/deploy-infra.yaml`

```yaml
name: Deploy AWS Infrastructure (Terraform)

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

**Setup:**
- Store your AWS credentials in GitHub repository secrets as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

---

## 5. Best Practices & Notes

- Use IaC (Terraform, CloudFormation, or CDK) for all resource and policy management.
- **Root user MFA** and **account contact information** must be set manually in the AWS Console.
- Some billing/account settings (like enabling Cost Explorer) may need manual configuration.
- All deployments and updates can be automated via CLI or CI/CD.
- For resource cleanup, use `terraform destroy`.

---

## 6. Checking Deployment and Outputs

To check stack outputs after apply:

```sh
terraform output
```

To see all resources managed by Terraform:

```sh
terraform state list
```

To inspect a specific output (e.g., IAM credentials):

```sh
terraform output admin_user_name
terraform output admin_access_key_id
terraform output admin_secret_access_key
```

---

## 8. File Structure

```
.
├── budget.tf
├── iam-admin.tf
├── vpc.tf
├── .github/
│   └── workflows/
│       └── deploy-infra.yaml
└── aws-devops-quickstart-terraform.md
```

---

## 9. Resource Cleanup

To remove all provisioned resources:

```sh
terraform destroy
```

---

## 10. Manual Steps & Caveats

- **Root user MFA**: Must be enabled via AWS Console for security. Cannot be automated by Terraform or CLI.
- **IAM user MFA**: Enable manually for created admin user via AWS Console or CLI.
- **Budget alert email**: Ensure you verify the email and check your inbox after deployment.
- **Account contacts**: Update contact info and enable Cost Explorer in the AWS Console.