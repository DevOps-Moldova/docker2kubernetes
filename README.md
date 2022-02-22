# From docker to Kubernetes

## Required local packages

- docker
- docker-compose
- terraform

## Dockerization

Each application contain an multistage `Dockerfile` which make builds and prepare final docker image. No need for local JDK or NodeJS instalation

### Java application

``` bash
cd java/employee-management-backend/
docker build -t employee-backend:latest -f pipelines/Dockerfile .
```

### Angular application

``` bash
cd angular/employee-management-frontend/
docker build -t employee-frontend:latest -f pipelines/Dockerfile .

```

## Local development

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

### terraform