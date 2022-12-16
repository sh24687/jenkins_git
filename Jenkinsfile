pipeline {
    agent any

    stages {
        stage("Set Variable") {
            steps {
                script {
                    IMAGE_NAME = "이미지명"
                    IMAGE_STORAGE = "Container Registry 경로"
                    IMAGE_STORAGE_CREDENTIAL = "Container Registry 접근 Credential id"
                    SSH_CONNECTION = "접속할 계정@배포할 서버 IP"
                    SSH_CONNECTION_CREDENTIAL = "SSH 서버 접근 Credential id"
                    SLACK_CHANNEL = "#알림받을 채널"
                    SLACK_SUCCESS_COLOR = "#2C953C";
                    SLACK_FAIL_COLOR = "#FF3232";
                    // Git Commit 계정
                    GIT_COMMIT_AUTHOR = sh(script: "git --no-pager show -s --format=%an ${env.GIT_COMMIT}", returnStdout: true).trim();
                    // Git Commit 메시지
                    GIT_COMMIT_MESSAGE = sh(script: "git --no-pager show -s --format=%B ${env.GIT_COMMIT}", returnStdout: true).trim();
                }
            }
            post {
                success {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_SUCCESS_COLOR,
                        message: "==================================================================\n배포 파이프라인이 시작되었습니다.\n${env.JOB_NAME}(${env.BUILD_NUMBER})\n${GIT_COMMIT_AUTHOR} - ${GIT_COMMIT_MESSAGE}\n${env.BUILD_URL}"
                    )
                }
            }
        }

        stage("Clean Build Test") {
            steps {
                sh "./gradlew clean build test"
            }
            post {
                success {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_SUCCESS_COLOR,
                        message: "Build Test에 성공하였습니다."
                    )
                }
                failure {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_FAIL_COLOR,
                        message: "Build Test에 실패하였습니다."
                    )
                }
            }
        }

        stage("Build Container Image") {
            steps {
                script {
                    image = docker.build("${IMAGE_STORAGE}/${IMAGE_NAME}")
                }
            }
            post {
                success {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_SUCCESS_COLOR,
                        message: "Container Image Build에 성공하였습니다."
                    )
                }
                failure {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_FAIL_COLOR,
                        message: "Container Image Build에 실패하였습니다."
                    )
                }
            }
        }

        stage("Push Container Image") {
            steps {
                script {
                    docker.withRegistry("https://${IMAGE_STORAGE}", IMAGE_STORAGE_CREDENTIAL) {
                        image.push("${env.BUILD_NUMBER}")
                        image.push("latest")
                        image
                    }
                }
            }
            post {
                success {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_SUCCESS_COLOR,
                        message: "Container Image Push에 성공하였습니다."
                    )
                }
                failure {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_FAIL_COLOR,
                        message: "Container Image Push에 실패하였습니다."
                    )
                }
            }
        }

        stage("Server Run") {
            steps {
                sshagent([SSH_CONNECTION_CREDENTIAL]) {
                    // 최신 컨테이너 삭제
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker rm -f ${IMAGE_NAME}'"
                    // 최신 이미지 삭제
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker rmi -f ${IMAGE_STORAGE}/${IMAGE_NAME}:latest'"
                    // 최신 이미지 PULL
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker pull ${IMAGE_STORAGE}/${IMAGE_NAME}:latest'"
                    // 이미지 확인
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker images'"
                    // 최신 이미지 RUN
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${IMAGE_STORAGE}/${IMAGE_NAME}:latest'"
                    // 컨테이너 확인
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_CONNECTION} 'docker ps'"
                }
            }
            post {
                success {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_SUCCESS_COLOR,
                        message: "배포에 성공하였습니다.\n=================================================================="
                    )
                }
                failure {
                    slackSend (
                        channel: SLACK_CHANNEL,
                        color: SLACK_FAIL_COLOR,
                        message: "배포에 실패하였습니다.\n=================================================================="
                    )
                }
            }
        }
    }

}
