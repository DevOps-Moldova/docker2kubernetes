resource "helm_release" "mysql" {
  name = "mysql"

  #   repository = "https://charts.bitnami.com/bitnami"
  chart = "stable/mysql"

  namespace = "default"

  set {
    name  = "imageTag"
    value = "5.7"
  }
  set {
    name  = "mysqlUser"
    value = "java_app"
  }
  set {
    name  = "mysqlPassword"
    value = "pass123"
  }

  set {
    name  = "mysqlDatabase"
    value = "employee_db"
  }

}