# Jenkins-Terraform

In this project, you will learn how to deploy an EC2 Instance, bootstrap the EC2 instance to install and start Jenkins, create a Jenkins Security Group, create a private Jenkins S3 bucket to store Jenkins artifact, add a variables.tf file, providers.tf file, and an outputs.tf file using Terraform. Additionally, you will learn how to create a simple Jenkins pipeline.

# Prerequisites:

-> AWS CLI installed & configured
-> Terraform installed & configured
-> IDE of your choice

# Step-1:

Create an EC2 Instance of Linux based and install AWS CLI and Terraform and also configure them.

Create a new folder, then cd into the folder.

Create the main.tf, variable.tf, providers.tf, and outputs.tf files

The main.tf file will contain the main set of configurations.
```
resource "aws_instance" "instance" {
ami                    = var.ami
instance_type          = var.instance
user_data              = var.ec2_user_data
vpc_security_group_ids = [aws_security_group.security_group.id]

tags = {
 Name                  = "Jenkins Instance"
}
}

resource "aws_security_group" "security_group" { 
vpc_id                 = var.vpc

ingress {
description            = "Allow SSH from my Public IP"
from_port              = 22
to_port                = 22
protocol               = "tcp"
cidr_blocks            = ["0.0.0.0/0"]
}

ingress {
description            = "Allows Access to the Jenkins Server"
from_port              = 8080
to_port                = 8080
protocol               = "tcp"
cidr_blocks            = ["0.0.0.0/0"]
}

ingress {
description           = "Allow HTTPS access"
from_port             = 443
to_port               = 443
protocol              = "tcp"
cidr_blocks           = ["0.0.0.0/0"]
}

egress {
from_port             = 0
to_port               = 0
protocol              = "-1"
cidr_blocks           = ["0.0.0.0/0"]
}
tags = {
  Name                = "Jenkins Security Group"
}
}

resource "aws_s3_bucket" "terraform-jenkins" {
bucket                = "terraform-jenkins"
}

resource "aws_s3_bucket_acl" "jenkinsbucketacl" {
bucket                = aws_s3_bucket.terraform-jenkins.id
acl                   = "private"
}
```
The variable.tf file will contain the declaration of all the variables.
```
variable "vpc" {
  description         = "The Default VPC of EC2"
  type                = string
  default             = "vpc-07aa3898c8a4dcf4e"
}

variable "ami" {
  description         = "The AMI ID of the Instance"
  type                = string
  default             = "ami-00c39f71452c08778"
}

variable "instance" {
  description         = "The Instance Type of EC2"
  type                = string
  default             = "t2.micro"
}

variable "ec2_user_data" {
  description        = "User Data for Jenkins EC2"
  type               = string
  default            = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo yum upgrade
  sudo amazon-linux-extras install java-openjdk11 -y
  sudo yum install -y jenkins
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF
}
```

The providers.tf file allows Terraform to interact with your desired cloud provider.
```
provider "aws" {
    region         = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source       = "hashicorp/aws"
      version      = "~> 4.0"
    }
  }
}
```

The outputs.tf file lets you export structured data about your resources.
```
output "public_ip" {
    value           = aws_instance.instance.public_ip
}
```
# Step-2:  — Run it with Terraform

1. The terraform init command will initialize the working directory containing Terraform configuration files and install any required plugins.

![Screenshot (6)](https://user-images.githubusercontent.com/98457309/229349806-05ce4f3b-09c7-4046-bcda-527523666151.png)

2. Run terraform fmt and terraform validate command validates the configuration files in a directory.

3. The terraform plan command lets you preview the actions Terraform would take to modify your infrastructure.

![Screenshot-7](https://user-images.githubusercontent.com/98457309/229349960-6867e406-4a43-4c60-b4c5-458eb6c3d6c1.png)

4. The terraform apply command executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure.

![Screenshot-8](https://user-images.githubusercontent.com/98457309/229350056-f1fac63f-222e-4b89-8cce-4d603932533e.png)

5. You can confirm the creation of the EC2 Instance by checking the console.

![Screenshot-9](https://user-images.githubusercontent.com/98457309/229350143-63884fd5-6cfc-4104-8d78-197a1d414a9e.png)

# Step - 3:

1. Jenkins Pipeline is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins.

2. To create a Jenkins Pipeline, enter ‘Public IP of EC2 Instance:8080’ in the web browser. After configuring and logging into Jenkins, you should see a screen that looks similar to the one below.

3.  You can see the Jenkins Pipeline running on 8080 port.


Till Now, we learned how to create an EC2 Instance, install and start Jenkins, create a Jenkins Security Group, create a private Jenkins S3 bucket to store Jenkins artifact, add a variable.tf file, providers.tf file, and an outputs.tf file using Terraform. 






