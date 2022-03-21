pipeline {
    agent any
    
    options {
        disableConcurrentBuilds()
    }
    environment {
        def serviceName = ""; 
        def repoName = "";
        def branchName = "";
        def commitID = "";
        def versionName = "";
        def dockerRegistry = "209591221760.dkr.ecr.eu-west-1.amazonaws.com"
        def imageName = "";
        def dockerImage = null;
    }

    stages {
        stage('Init') {
            steps {
                script {
                    echo 'Init variables'

                    serviceName =  "backend"
                    branchName = env.BRANCH_NAME
                    versionName = env.BRANCH_NAME
                    imageName = "${serviceName}:${versionName}"
                }
                
            }
        }
        stage('clone') {
            steps {
                script {
                    echo 'Clone repository'

                    checkout scm
                }
            }
        }
        stage('build') {
            steps {
                script {
                    echo 'Build docker image'
                    dir('java/employee-management-backend/') {
                        dockerImage = docker.build(imageName, , "-f pipelines/Dockerfile .")
                    }
                    
                }
            }
        }
        stage('docker publish') {
            steps {
                script {
                    echo 'Publish docker image'
                     docker.withRegistry("https://${dockerRegistry}",  'ecr:eu-west-1:ecr_key') {

                        dockerImage.push()
                     }
                    
                }
            }
        }
    }
}