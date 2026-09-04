pipeline {
    agent any

    environment {
        IMAGE_NAME = "yourdockerhubusername/devops-cicd-app"
        CONTAINER_NAME = "devops-cicd-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                dir('app') {
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install -r requirements.txt
                        pip install pytest
                        pytest test_app.py
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 5000:5000 --restart unless-stopped ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "Deployed successfully! Visit http://<your-ec2-ip>:5000"
        }
        failure {
            echo "Pipeline failed. Rolling back is manual for now — check logs above."
        }
    }
}
