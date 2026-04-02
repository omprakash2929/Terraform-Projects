# Multi-Environment Infrastructure with Terraform & Ansible

Provision and configure **dev**, **staging**, and **production** environments on AWS using Terraform (infrastructure) and Ansible (configuration management).

---

## Tech Stack

- **Terraform** — AWS resource provisioning (EC2, S3, DynamoDB)
- **Ansible** — Server configuration & Nginx deployment
- **AWS** — Cloud provider

---

## Project Structure

```
.
├── ansible/
│   ├── inventories/
│   │   ├── dev
│   │   ├── stg
│   │   └── prod
│   ├── playbooks/
│   │   ├── install_nginx_playbook.yml
│   │   └── nginx-role/
│   │       ├── tasks/main.yml
│   │       ├── files/index.html
│   │       └── handlers/main.yml
│   └── update_inventories.sh
└── terraform/
    ├── infra/
    │   ├── bucket.tf
    │   ├── dynamodb.tf
    │   ├── ec2.tf
    │   ├── output.tf
    │   └── variable.tf
    ├── main.tf
    ├── providers.tf
    └── terraform.tf
```

---

## Quick Start

### 1. Install Dependencies

**Terraform**
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

**Ansible**
```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update && sudo apt install ansible
```

---

### 2. Provision Infrastructure

```bash
cd terraform

# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -f devops-key -N ""
chmod 400 devops-key

# Deploy
terraform init
terraform plan
terraform apply
```

This creates EC2 instances, S3 buckets, and DynamoDB tables for all three environments.

---

### 3. Configure Servers with Ansible

```bash
cd ../ansible

# Sync Terraform IPs into inventory files
chmod +x update_inventories.sh && ./update_inventories.sh

# Deploy Nginx to each environment
ansible-playbook -i inventories/dev  playbooks/install_nginx_playbook.yml
ansible-playbook -i inventories/stg  playbooks/install_nginx_playbook.yml
ansible-playbook -i inventories/prod playbooks/install_nginx_playbook.yml
```

---

### 4. Verify

SSH into any instance:
```bash
ssh -i terraform/devops-key ubuntu@<ec2-public-ip>
```

Then open `http://<ec2-public-ip>` in your browser — you should see the custom Nginx page.

---

### 5. Teardown

```bash
cd terraform
terraform destroy --auto-approve
```

> ⚠️ This permanently deletes all provisioned resources. Back up any important data first.

---

## How It Works

| Step | Tool | What Happens |
|------|------|-------------|
| Provision | Terraform | Creates EC2, S3, DynamoDB per environment via reusable `infra` module |
| Sync IPs | Shell script | Reads Terraform outputs → writes Ansible inventory files |
| Configure | Ansible | Installs & starts Nginx, deploys custom `index.html` via `nginx-role` |
| Destroy | Terraform | Tears down all AWS resources cleanly |