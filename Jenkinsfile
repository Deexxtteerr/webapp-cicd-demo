pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Deexxtteerr/webapp-cicd-demo.git'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building web application...'
                sh 'ls -la src/'
            }
        }
        
        stage('Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        sh 'export AWS_DEFAULT_REGION=us-west-1'
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}

