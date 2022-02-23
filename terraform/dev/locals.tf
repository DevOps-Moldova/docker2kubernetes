locals {

  vpc_public_ips = [
    for ip in module.vpc.nat_public_ips : "${ip}/32"
  ]

  tags = {
    Environment = var.cluster_name
    Owner       = "Andrei Prescornic"
    Project     = "DevOps"
    Scope       = "Training"
  }
}