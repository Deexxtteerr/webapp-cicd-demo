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
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}

