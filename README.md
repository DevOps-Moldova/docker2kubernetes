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

Some configuration require more steps or operations. Ansible will manage packages confiugration and os customizations. Package `ansible` is available in or repositories

``` bash
cd ansible
ansible-playbook setup_jenkins.yml -i inventories/dev/ --private-key ../terraform/dev/ssh_key 
```
