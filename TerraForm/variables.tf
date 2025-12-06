variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "vpc_01"
}

variable "subnet_name" {
  description = "Name tag for subnet"
  type        = string
  default     = "subnet_01"

}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "IGW_Name" {
  description = "Name tag for Internet Gateway"
  type        = string
  default     = "igw_01"
}

variable "Route_Table_Name" {
  description = "Name tag for Route Table"
  type        = string
  default     = "rt_01"

}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "allowed_admin_cidr" {
  description = "CIDR allowed to access SSH/Jenkins/Sonar"
  type        = string
  default     = "223.196.193.12/32"
}

variable "ami_id" {
  type        = string
  description = "AMI for Jenkins and Sonar"
}


variable "jenkins_instance_type" {
  description = "Default instance type for Jenkins"
  type        = string
  default     = "t3.micro"
}

variable "jenkins_instance_name" {
  description = "Jenkins Server Name Tag"
  type        = string
  default     = "Jenkins-Server"
}

variable "sonar_instance_type" {
  description = "Default instance type for SonarQube (requires more resources)"
  type        = string
  default     = "t3.medium"
}

variable "sonarqube_instance_name" {
  description = "SonarQube Server Name Tag"
  type        = string
  default     = "SonarQube-Server"
}

variable "key_name" {
  description = "The name of the SSH Key Pair to use"
  type        = string
}