
provider "local" {

}

provider "kubernetes" {
  config_path = var.kubeconfig_output_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_output_path
  }
}
