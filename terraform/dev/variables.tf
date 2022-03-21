variable "cluster_name" {
  type        = string
  description = "Environment name"
  default     = "training"
}


variable "region" {
  type        = string
  description = "region"
  default     = "eu-west-1"
}

variable "availability_zones" {
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}

variable "vpc_cidr" {
  default = "172.136.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "172.136.0.0/20",
    "172.136.16.0/20",
    "172.136.32.0/20"
  ]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "filugil it i"
  default = [
    "172.136.112.0/20",
    "172.136.128.0/20",
    "172.136.144.0/20"
  ]
}

variable "trusted_ip" {
  type        = list(string)
  description = "Whitelisted IPs"
  default = [
    "217.12.117.42/32",
    "37.233.62.175/32",
    "188.237.201.94/32"
  ]
}

variable "applications" {
  type        = list(string)
  description = "List of deployed applications"
  default = [
    "frontend",
    "backend",
  ]

}

variable "jenkins_instance_size" {
  type        = string
  description = "EC2 instance type for jenkins server"
  default     = "t2.medium"
}

variable "ami_name" {
  type        = string
  description = "Ubuntu AMI name"
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220131"
}

variable "ssh_user" {
  type        = string
  description = "Jenkins ssh username"
  default     = "demouser"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance_class name"
  default     = "db.t3.micro"
}

variable "db_username" {
  type        = string
  description = "Database Username"
  default     = "demoadmin"
}

variable "db_dbname" {
  type        = string
  description = "Database name"
  default     = "employees"
}

variable "kubeconfig_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Assumed to be a directory if the value ends with a forward slash `/`."
  type        = string
  default     = "./kubeconfig"
}