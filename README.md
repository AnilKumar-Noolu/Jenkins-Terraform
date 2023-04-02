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

