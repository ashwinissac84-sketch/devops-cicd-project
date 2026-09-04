# CI/CD Pipeline for a Dockerized Flask App on AWS

Automated pipeline that takes code from GitHub to a running container on AWS EC2, using Jenkins, Docker, and Terraform-provisioned infrastructure.

## Architecture

```
Developer -> GitHub -> Jenkins (webhook trigger)
                          |
                          v
                  Install deps + run tests
                          |
                          v
                   Build Docker image
                          |
                          v
                 Push image to Docker Hub
                          |
                          v
              SSH/local docker run on EC2
                          |
                          v
              Flask app live on port 5000
                          |
                          v
              CloudWatch (logs + basic metrics)
```

Infrastructure (VPC, subnet, security group, EC2 instance, IAM role) is provisioned with Terraform — nothing was clicked into existence manually in the AWS console.

## Tech Stack
- **Cloud:** AWS (EC2, VPC, IAM, CloudWatch)
- **IaC:** Terraform
- **CI/CD:** Jenkins
- **Containerization:** Docker
- **App:** Python (Flask)
- **VCS:** Git / GitHub

## How it works
1. Terraform provisions a VPC, public subnet, security group, and a single EC2 instance with Docker and Jenkins pre-installed via user-data.
2. Jenkins is configured with a pipeline (see `Jenkinsfile`) triggered by a GitHub webhook on every push to `main`.
3. The pipeline installs dependencies, runs unit tests (`pytest`), builds a Docker image, pushes it to Docker Hub, then redeploys the container on the same EC2 instance.
4. CloudWatch Agent ships basic system logs/metrics for the instance.

## Running it yourself
See `terraform/` for infra setup and the root `Jenkinsfile` for the pipeline definition.

## What I'd add next
- Move deploy target to a separate instance/ASG rather than co-locating Jenkins and the app
- Add a staging environment before production deploy
- Automated rollback on failed health check
- Move from Docker Hub to Amazon ECR
