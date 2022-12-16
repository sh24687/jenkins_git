pipeline {
    agent none
    options { skipDefaultCheckout(true) }
    stages {
        stage('Start') {
            agent any
            steps {
                slackSend (channel: '#migrator', color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            }
        }
        stage('Build and Test') {
            agent {
                docker {
					...
                }
            }
            options { skipDefaultCheckout(false) }
            steps {
                ...
            }
        }
        stage('Docker build') {
            agent any
            steps {
                ...
            }
        }
        stage('Docker run') {
            agent any
            steps {
				...
            }
        }
    }
    post {
        success {
            slackSend (channel: '#migrator', color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure {
            slackSend (channel: '#migrator', color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}
