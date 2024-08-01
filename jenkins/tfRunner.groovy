@Library('k8sLib@master') _

pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
        CLUSTER_NAME = 'sandbox-eks-cluster'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/Andreichenko/aws_sandbox.git', credentialsId: 'github-pat'
            }
        }

        stage('Configure AWS CLI') {
            steps {
                withCredentials([string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $AWS_DEFAULT_REGION
                    '''
                }
            }
        }

        stage('Prepare Environment') {
            steps {
                sh 'pip install awscli'
                sh 'pip install boto3'
            }
        }

        stage('Run Python Script') {
            steps {
                sh 'python3 s3bucket.py'
            }
        }

       stage('Deploy CloudFormation') {
            steps {
                withCredentials([string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                                string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        catchError(buildResult: null, stageResult: null) {
                            sh 'aws cloudformation create-stack --stack-name my-s3-stack --template-body file://cloudformation/s3.yaml --capabilities CAPABILITY_NAMED_IAM'
                            sh 'aws cloudformation wait stack-create-complete --stack-name my-s3-stack'
                        }
                        if (currentBuild.result == 'FAILURE' && currentBuild.rawBuild.getLog(100).contains('AlreadyExistsException')) {
                            echo 'Stack already exists. Updating stack.'
                            currentBuild.result = null
                            sh 'aws cloudformation update-stack --stack-name my-s3-stack --template-body file://cloudformation/s3.yaml --capabilities CAPABILITY_NAMED_IAM'
                            sh 'aws cloudformation wait stack-update-complete --stack-name my-s3-stack'
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    try {
                        sh 'cd ./terraform/staging/ && terraform init'
                    } catch (Exception e) {
                        echo 'Terraform init failed. Retrying with -reconfigure flag...'
                        sh 'cd ./terraform/staging/ && terraform init -reconfigure'
                    }
                }
            }
        }


        stage('Terraform Plan') {
            steps {
                withCredentials([aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    cd ./terraform/staging/
                    terraform plan -lock=false -out=tfplan'''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                 withCredentials([aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    cd ./terraform/staging/
                    terraform init
                    terraform apply -input=false tfplan'''
                    //terraform apply -lock=false -out=tfplan'''
                 }
            }
        }

        stage('Save Kubeconfig') {
              steps {
                script {
                  eksConfig.save('us-east-1', env.CLUSTER_NAME)
                }
            }
        }
    }
}
