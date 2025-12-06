# Define the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#------create vpc -------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

#------create subnet-------
resource "aws_subnet" "subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

#------create internet gateway-------
resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.IGW_Name
  }
}

#-----create route table-------
resource "aws_route_table" "rt_01" {
  vpc_id = aws_vpc.main.id

  # FIXED: This MUST be 0.0.0.0/0 for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_01.id
  }

  tags = {
    Name = var.Route_Table_Name
  }
}

# -----associate route table with subnet-------
resource "aws_route_table_association" "rta_01" {
  subnet_id      = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.rt_01.id
}

# --- Security Group for Jenkins and SonarQube ---
resource "aws_security_group" "devops_sg" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "devops-sg-"
  description = "Allows inbound traffic for SSH, Jenkins (8080), and SonarQube (9000)"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-Services-SG"
  }
}

# --- EC2 Instance for Jenkins ---
resource "aws_instance" "jenkins_server" {
  ami                         = var.ami_id
  instance_type               = var.jenkins_instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_01.id
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]

  user_data = file("jenkins_install.sh")

  tags = {
    Name = var.jenkins_instance_name
  }
}

# --- EC2 Instance for SonarQube ---
resource "aws_instance" "sonarqube_server" {
  ami                         = var.ami_id
  instance_type               = var.sonar_instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_01.id
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]

  user_data = file("sonarqube_install.sh")

  tags = {
    Name = var.sonarqube_instance_name
  }
}
