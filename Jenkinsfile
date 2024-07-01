pipeline {
    agent any

    environment {
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('jenkins002')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/shivatechnology23/jenkins002.git'
            }
        }

        // stage('Install Terraform') {
        //     steps {
        //         sh '''
        //             # Install Terraform
        //             curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        //             sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        //             sudo apt-get update && sudo apt-get install terraform
        //         '''
        //     }
        // }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        cleanup {
            sh 'rm -rf .terraform'
        }
    }
}
