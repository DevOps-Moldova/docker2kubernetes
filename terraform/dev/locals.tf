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

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG

}