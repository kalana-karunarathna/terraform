# Terraform and Ansible Multi-Environment AWS Infrastructure

This project provisions AWS infrastructure with Terraform and configures the
created servers with Ansible. It is organized for separate `dev`, `test`, and
`prod` environments, with reusable Terraform modules and environment-specific
state files.

## Project Structure

```text
.
├── ansible/
│   ├── ansible.cfg
│   ├── inventories/
│   │   ├── dev.ini
│   │   ├── test.ini
│   │   └── prod.ini
│   ├── playbooks/
│   │   ├── deploy-app.yml
│   │   ├── setup-docker.yml
│   │   └── setup-nginx.yml
│   └── roles/
│       ├── app/
│       ├── docker/
│       └── nginx/
└── terraform/
    ├── backend-setup/
    ├── environments/
    │   ├── dev/
    │   ├── test/
    │   └── prod/
    └── modules/
        ├── alb/
        ├── ec2/
        ├── rds/
        ├── security-group/
        └── vpc/
```

## What It Creates

### Terraform

- Remote Terraform state backend using S3 and DynamoDB locking
- Environment-specific VPC networking
- Public subnet, route table, and internet gateway
- Security groups for SSH, HTTP, HTTPS, and custom ingress rules
- EC2 instances for application hosts
- Production Application Load Balancer
- Production MySQL RDS instance

The `dev` and `test` environments currently create VPC, security group, and EC2
resources. The `prod` environment also includes ALB and RDS modules.

### Ansible

- Installs and configures Docker
- Installs and configures Nginx
- Deploys a sample application container
- Uses separate inventories for `dev`, `test`, and `prod`

## Prerequisites

Install the following tools before using this project:

- Terraform
- Ansible
- AWS CLI
- An AWS account with permissions to create VPC, EC2, ALB, RDS, S3, and DynamoDB
  resources
- An EC2 key pair for SSH access

Configure AWS credentials before running Terraform:

```bash
aws configure
```

## Configure Remote State

Create the S3 bucket and DynamoDB table used for remote state locking:

```bash
cd terraform/backend-setup
terraform init
terraform plan
terraform apply
```

The backend setup currently creates:

- S3 bucket: `kalana-terraform-state-bucket-2026`
- DynamoDB table: `terraform-state-locks`

## Deploy an Environment

Choose an environment directory:

```bash
cd terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Create a `terraform.tfvars` file with values for the environment:

```hcl
aws_region         = "us-east-1"
env_name           = "dev"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"
ssh_cidr           = "YOUR_PUBLIC_IP/32"
ami_id             = "ami-xxxxxxxxxxxxxxxxx"
instance_type      = "t3.micro"
key_name           = "your-key-pair-name"
```

For `prod`, also provide values required by the ALB and RDS setup, such as:

```hcl
public_subnet_cidr_2 = "10.2.2.0/24"
availability_zone_2  = "us-east-1b"
db_name              = "appdb"
db_username          = "admin"
db_password          = "change-this-password"
```

Review and apply the Terraform changes:

```bash
terraform plan
terraform apply
```

## Run Ansible

Update the relevant inventory file in `ansible/inventories/` with the public IP
address of the EC2 instance created by Terraform.

From the `ansible` directory, run the playbooks:

```bash
cd ansible
ansible-playbook playbooks/setup-docker.yml
ansible-playbook playbooks/setup-nginx.yml
ansible-playbook playbooks/deploy-app.yml
```

To use a specific inventory file:

```bash
ansible-playbook -i inventories/prod.ini playbooks/setup-docker.yml
```

## Useful Terraform Commands

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Clean Up

Destroy resources from each environment directory when they are no longer
needed:

```bash
cd terraform/environments/dev
terraform destroy
```

Destroy the backend resources only after all environment state files are no
longer needed:

```bash
cd terraform/backend-setup
terraform destroy
```

## Notes

- Do not commit secrets such as database passwords or private SSH keys.
- Restrict `ssh_cidr` to your public IP address instead of opening SSH to the
  internet.
- Keep `dev`, `test`, and `prod` state files separate to avoid accidental
  cross-environment changes.
