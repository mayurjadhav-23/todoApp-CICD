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
                    sh """
                        cat deploy/deploy.yaml
                        sed -i 's/32/${BUILD_NUMBER}/g' deploy.yaml
                        cat deploy/deploy.yaml
                        git add deploy/deploy.yaml
                        git commit -m 'Updated deploy.yaml | Jenkins Pipeline'
                        git remote -v
                        git push
                    """
                }
            }
        }
    }
}
