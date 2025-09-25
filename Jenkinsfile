pipeline {
    agent { label "vinod" }

    environment {
        APP_NAME = 'todo-app'
        DOCKER_IMAGE = "mayurj023/${APP_NAME}:${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = 'dockerhub' // Docker Hub username + token
        GITHUB_CREDENTIALS = 'github-token'
    }

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build") {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage("Push Docker Image") {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: "${DOCKERHUB_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage("Checkout & Update K8S manifest SCM") {
            steps {
                script {
                    // Use GitHub credentials for authentication
                    withCredentials([string(credentialsId: "${GITHUB_CREDENTIALS}", variable: 'GITHUB_TOKEN')]) {
                        sh """
                            # Configure git user (required for commits)
                            git config user.email "mayurjadhav0232.com"
                            git config user.name "mayurjadhav-23"
                            

                            cat deploy/deploy.yaml
                            
                            sed -i "s|mayurj023/todo-app:v.*|mayurj023/todo-app:${BUILD_NUMBER}|g" deploy/deploy.yaml
                            
                            cat deploy/deploy.yaml
                            
                            git add deploy/deploy.yaml
                            git commit -m 'Updated deploy.yaml | Jenkins Pipeline Build ${BUILD_NUMBER}'
                            
                            # Push using the GitHub token
                            git push https://\${GITHUB_TOKEN}@github.com/mayurjadhav-23/todoApp-CICD.git HEAD:main
                        """
                    }
                }
            }
        }
    }
}
