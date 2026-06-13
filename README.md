# AWS CloudOps Monitoring System Terraform

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to automate the deployment of AWS infrastructure and monitoring services.

The solution provisions a secure AWS environment consisting of networking, compute, monitoring, and alerting components.

## Architecture

Internet
│
├── Internet Gateway
│
├── Public Subnet
│
├── EC2 Instance
│
├── CloudWatch Alarm
│
└── SNS Email Notification

## AWS Services Used

- Amazon VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- Amazon EC2
- Amazon CloudWatch
- Amazon SNS

## Terraform Resources

- aws_vpc
- aws_subnet
- aws_internet_gateway
- aws_route_table
- aws_route_table_association
- aws_security_group
- aws_instance
- aws_sns_topic
- aws_sns_topic_subscription
- aws_cloudwatch_metric_alarm

## Features

- Automated infrastructure provisioning using Terraform
- Secure VPC and subnet configuration
- EC2 instance deployment
- CloudWatch CPU monitoring
- SNS email notifications for high CPU utilization
- Infrastructure as Code (IaC) best practices

## Deployment Commands

```bash
terraform init
terraform plan
terraform apply
