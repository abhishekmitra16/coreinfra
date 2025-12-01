# CoreInfra - Production-Ready AWS Infrastructure

A comprehensive, production-ready Terraform infrastructure project demonstrating enterprise-grade AWS cloud architecture with modular design, security best practices, and scalability. This is a complete, real-world example suitable for deploying containerized applications at scale.

## 📋 Project Overview

**CoreInfra** is a fully-managed AWS infrastructure-as-code project that provisions everything needed to deploy containerized web applications in production. This portfolio project showcases professional-grade infrastructure design, security practices, and operational patterns used in enterprise environments.

### What This Project Demonstrates

- ✅ **Enterprise Architecture** - Multi-tier, highly available infrastructure
- ✅ **Infrastructure as Code** - 100% reproducible, version-controlled infrastructure  
- ✅ **Security Best Practices** - Secrets management, encryption, least-privilege access
- ✅ **Modular Design** - Reusable, independently deployable components
- ✅ **Scalability** - Horizontal and vertical scaling patterns
- ✅ **Real-World Flexibility** - Works with or without existing AWS resources

## 🎯 Flexibility & Compatibility

This project is designed to work in different scenarios:

### ✅ Works With or Without Existing Resources

**Application Load Balancer** - Can provision new (`alb_exists = false`) or use existing (`alb_exists = true`)

**ACM Certificate** - Can create new (`use_existing_certificate = false`) or use existing (`use_existing_certificate = true`)

**ECS Cluster** - Can create new (`cluster_exists = false`) or use existing (`cluster_exists = true`)

**ECR Images** - If `initial_image_exists = false`, creates a **private sample image** for testing. If `true`, references existing images by `image_tag`

### Quick Configuration Examples

**Greenfield (Everything New):**
```hcl
alb_exists               = false
cluster_exists          = false
use_existing_certificate = false
initial_image_exists    = false
```

**Integrate with Existing Resources:**
```hcl
alb_exists               = true
cluster_exists          = true
use_existing_certificate = true
initial_image_exists    = false
```

**Custom Container Images:**
```hcl
initial_image_exists = true
image_tag           = "my-app-v1.0"
```

## 🏗️ Key Architecture Features

- **13 Modular Components** - VPC, ALB, ECS, ECR, RDS, RDS Proxy, Secrets Manager, CloudFront, S3, Route 53, VPC Endpoints
- **Multi-AZ Database** - High availability with automatic failover
- **Connection Pooling** - RDS Proxy for optimized database connections
- **Private Networking** - Database and sensitive resources in private subnets
- **Global CDN** - CloudFront distribution for static assets
- **Secrets Management** - Automated credential storage in AWS Secrets Manager
- **Flexible Deployment** - Works with new or existing AWS resources

## 🔐 Security Highlights

✅ Secrets Manager for database credentials (not in code)  
✅ Private subnets for RDS and application components  
✅ Security groups with least-privilege rules  
✅ S3 encryption with AES-256  
✅ Terraform state encrypted in S3 backend  
✅ VPC Endpoints for private AWS service access  
✅ No public database access  
✅ IAM roles with minimal permissions  

## 🚀 Quick Start

### Prerequisites
```bash
aws --version          # AWS CLI v2+
terraform --version    # 1.0+
git --version
```

### Step 1: Backend Setup
```bash
cd s3-backend

cat > terraform.tfvars << 'EOF'
profile     = "default"
region      = "us-east-1"
bucket_name = "coreinfra-terraform-state-$(date +%s)"
EOF

terraform init && terraform apply
cd ..
```

### Step 2: Configure Main Infrastructure
```bash
cat > terraform.tfvars << 'EOF'
region              = "us-east-1"
profile             = "default"
project_name        = "coreinfra"
environment         = "production"
alb_exists          = false
cluster_exists      = false
use_existing_certificate = false
initial_image_exists = false
domain_name         = "example.com"
sub_domain_name     = "app"
container_name      = "coreinfra-app"
ecs_cpu             = "256"
ecs_memory          = "512"
desired_count       = 2
EOF
```

### Step 3: Deploy
```bash
terraform init \
  -backend-config="bucket=YOUR_BUCKET_NAME" \
  -backend-config="key=coreinfra/terraform.tfstate" \
  -backend-config="encrypt=true" \
  -backend-config="use_lockfile=true"

terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

### Step 4: Verify Deployment
```bash
terraform output alb_dns_name
terraform output ecr_repository_url
terraform output rds_proxy_endpoint
```

## 📊 Common Tasks

**Deploy Your Container:**
```bash
# Get ECR credentials
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $(terraform output -raw ecr_registry_id).dkr.ecr.us-east-1.amazonaws.com

# Push image
docker tag myapp:latest $(terraform output -raw ecr_repository_url):latest
docker push $(terraform output -raw ecr_repository_url):latest

# Update ECS service
aws ecs update-service \
  --cluster coreinfra-cluster \
  --service coreinfra-app \
  --force-new-deployment
```

**Scale Application:**
```bash
# Horizontal scaling - Update desired count
sed -i 's/desired_count = .*/desired_count = 5/' terraform.tfvars
terraform apply

# Vertical scaling - Update task size
sed -i 's/ecs_cpu = .*/ecs_cpu = "512"/' terraform.tfvars
sed -i 's/ecs_memory = .*/ecs_memory = "1024"/' terraform.tfvars
terraform apply
```

**Check Deployment Status:**
```bash
aws ecs describe-clusters --cluster-names coreinfra-cluster
aws ecs describe-services --cluster coreinfra-cluster --services coreinfra-app
aws logs tail /ecs/coreinfra-app --follow
```

## 📋 Configuration Variables Summary

| Variable | Purpose | Default |
|----------|---------|---------|
| `project_name` | Resource naming prefix | `coreinfra` |
| `environment` | Deployment stage | `production` |
| `region` | AWS region | `us-east-1` |
| `alb_exists` | Use existing ALB | `false` |
| `cluster_exists` | Use existing ECS cluster | `false` |
| `use_existing_certificate` | Use existing ACM cert | `false` |
| `initial_image_exists` | ECR images exist | `false` |
| `image_tag` | Container image tag | `latest` |
| `ecs_cpu` | Task CPU units | `256` |
| `ecs_memory` | Task memory (MB) | `512` |
| `desired_count` | Number of tasks | `2` |
| `domain_name` | Your domain | `example.com` |
| `database_name` | MySQL database | `coreinfradb` |

## 🛠️ Advanced Examples

**Example: Multi-environment Deployment**
```bash
# Production
cat > terraform-prod.tfvars << 'EOF'
environment  = "production"
ecs_cpu      = "1024"
ecs_memory   = "2048"
desired_count = 5
EOF

terraform apply -var-file=terraform-prod.tfvars
```

**Example: Development Setup**
```bash
cat > terraform-dev.tfvars << 'EOF'
environment  = "development"
ecs_cpu      = "256"
ecs_memory   = "512"
desired_count = 1
EOF

terraform apply -var-file=terraform-dev.tfvars
```

**Example: Use Existing Resources**
```bash
cat > terraform.tfvars << 'EOF'
alb_exists               = true
cluster_exists          = true
use_existing_certificate = true
initial_image_exists    = false
image_tag              = "staging-latest"
EOF

# This will add new database and container service to existing infrastructure
terraform apply
```

## 📈 Scaling Strategies

**Horizontal Scaling:**
- Increase `desired_count` to add task replicas
- ALB distributes traffic across all tasks
- Recommended for handling traffic spikes

**Vertical Scaling:**
- Increase `ecs_cpu` and `ecs_memory`
- Tasks get more computational resources
- Use for CPU/memory intensive applications

**Database Scaling:**
- RDS supports storage auto-scaling up to 100GB
- RDS Proxy improves connection efficiency
- Multi-AZ ensures high availability

## 🎯 Best Practices Implemented

- ✅ Infrastructure as Code - Reproducible, version-controlled
- ✅ Modular Design - 13 independent modules
- ✅ Security First - Encryption, secrets management, private networking
- ✅ High Availability - Multi-AZ database, load balancing
- ✅ Monitoring Ready - CloudWatch integration
- ✅ Cost Optimized - Right-sized instances
- ✅ Documentation - Clear examples and guides
- ✅ Flexibility - Works with existing resources

## 📚 Key Outputs After Deployment

```bash
terraform output alb_dns_name           # Access point
terraform output ecr_repository_url     # Docker push destination
terraform output rds_proxy_endpoint     # Database connection
terraform output cloudfront_domain_name # CDN endpoint
terraform output ecs_cluster_name       # Cluster name
terraform output ecs_log_group_name     # CloudWatch logs
```

## 🔍 Troubleshooting

**ALB not responding:**
```bash
aws elbv2 describe-target-health --target-group-arn <ARN>
```

**ECS tasks failing:**
```bash
aws logs tail /ecs/coreinfra-app --follow
```

**Database connection issues:**
```bash
aws rds describe-db-proxies --db-proxy-name coreinfra-rds-proxy
```

## 🤝 Key Features

- Real-world infrastructure complexity
- Enterprise-grade security practices
- Cost-effective AWS resource management
- Modular, scalable architecture
- Professional documentation
- Operational maturity
- DevOps and IaC expertise

## 📖 Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/)

---

**Production-Ready** | **Enterprise-Grade** | **Fully Documented** | **Portfolio Showcase**

Last Updated: December 2025  
Terraform: 1.0+  
AWS Services: VPC, ALB, ECS, ECR, RDS, CloudFront, S3, Secrets Manager, Route 53
