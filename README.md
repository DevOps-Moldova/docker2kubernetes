# From docker to Kubernetes

## Required local packages

- docker
- docker-compose
- terraform
- ansible

## Dockerization

Each application contain an multistage `Dockerfile` which make builds and prepare final docker image. No need for local JDK or NodeJS instalation. `docker` can be installed from local packages

### Java application

Build and push docker images

``` bash
cd java/employee-management-backend/
docker build -t 209591221760.dkr.ecr.eu-west-1.amazonaws.com/backend -f pipelines/Dockerfile .
docker push 209591221760.dkr.ecr.eu-west-1.amazonaws.com/backend
```

### Angular application

Build and push docker images

``` bash
cd angular/employee-management-frontend/
docker build -t 209591221760.dkr.ecr.eu-west-1.amazonaws.com/frontend -f pipelines/Dockerfile .
docker push 209591221760.dkr.ecr.eu-west-1.amazonaws.com/frontend

```

## Local development

To help local developement and test localy locall services we can use docker-compose. All services and required databases are launched locally. Package `docker-compose` is available in most OS repositories

### Docker compose build

``` bash
cd docker-compose/
docker-compose build
```

### Docker compose start

``` bash
docker-compose up
```

### launch applications

Frontend is available on url <http://localhost:8080>
Backend is available on url <http://localhost:8081>
Swagger is available on url <http://localhost:8081/swagger-ui/>

## Environment provisioning

All resources are provisioned with terraform. You have to install `terraform` from local packages

### terraform

To launch all resources run:

``` bash
cd terraform/dev
terraform init
terraform apply 
```

resources deployed with terraform

- VPC
- IAM users
- Security groups
- EKS cluster
- ECR docker registry
- EC2 jenkins instance

## Environment configuration

Some configuration require more steps or operations. Ansible will manage packages confiugration and os customizations. Package `ansible` is available in os repositories

### Use ansible encryption

All ansible credentials should be encrypted

For this repository vault secret password is `6ha5trQ4Wyrf8rAcOp`

encrypt secrets

``` bash
ansible-vault encrypt --ask-vault-pass  --encrypt-vault-id default inventories/dev/group_vars/all/secrets.yaml
```

decrypt secrets

``` bash
ansible-vault decrypt --ask-vault-pass  inventories/dev/group_vars/all/secrets.yaml
```

### Run ansible playbooks

``` bash
cd ansible
ansible-playbook setup_jenkins.yml -i inventories/dev/ --private-key ../terraform/dev/ssh_key 
```

## Jenkins instance

Jenkins is fully configured with ANsible and dont need any manual changes.

Jenkins IP address can be extracted from terraform with command 

```bash
terraform output jenkins_public_ip
```

### Automatic builds

Builds are automatically triggered on changes in java or angular folders. Both services are in same repo but is recomended to keep services in separated git repositories. Build pipelines are configured in `[java|angular]repos/pipelines/build.groovy`

## Helm charts

All services deploys are made with helm charts

### Generate a new helm chart

```bash
cd helm-charts
helm create backend
```

After creation service require some customizations in `values.yaml` for image name and some environment variables if used.

All service credentials should be stored in a secured storage liek `kubernetes secrets`, `AWS KMS` or `hashicorm vault`. In this demo helm credentials are plaintext in values.yaml (insecured) and deployed in kubernetes secrets.

### Deploy an helm chart

```bash
helm upgrade -i backend helm-charts/backend
# Or with specific image tag
helm upgrade -i backend helm-charts/backend --set image.tag=feature_branch
```

### Publish deployed applications

Frontend application is configured with srvice type `LoadBalancer`. AWS will expose that resource as public LoadBalancer. LoadBalancer address can be detected with kubcctl

```bash
kubectl get service frontend
```

Application can be accessed via URL <http://a82606d778f674a2b907d2cbb61447d1-849513479.eu-west-1.elb.amazonaws.com>
