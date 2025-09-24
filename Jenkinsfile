pipeline{
    agent { label "vinod" }
    environment {
        APP_NAME = 'todo-app'
        DOCKER_IMAGE = "mayurj023/${APP_NAME}:${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = 'dockerhub'  // Docker Hub username + token
    }
    stages{
        stage("Checkout"){
            steps{
                    scm Checkout
            }
        }
        stage("Build"){
            steps{
                script{
                    sh"docker build -t mayurj023/${APP_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Checkout K8S manifest SCM'){
            steps {
                script{
                    sh "cat deploy.yaml
                        sed -i "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote -v
                        git push"
                }
            }
        }
}