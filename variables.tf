variable "vpc" {
  description = "The Default VPC of EC2"
  type        = string
  default     = "vpc-07aa3898c8a4dcf4e"
}

variable "ami" {
  description = "The AMI ID of the Instance"
  type        = string
  default     = "ami-00c39f71452c08778"
}

variable "instance" {
  description = "The Instance Type of EC2"
  type        = string
  default     = "t2.micro"
}

variable "ec2_user_data" {
  description = "User Data for Jenkins EC2"
  type        = string
  default     = <<-EOF
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
