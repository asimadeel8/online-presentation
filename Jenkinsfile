pipeline {
    agent any

    environment {
        // Your Vercel Token ID from Jenkins Credentials
        VERCEL_TOKEN = credentials('vercel_token')
        // Your Docker Hub ID from Jenkins Credentials
        DOCKER_CREDS = credentials('docker_hub')
        // Your Docker Hub Username
        DOCKER_USER = 'mohammadasimadeel'
        // Name of the image
        IMAGE_NAME = 'online-presentation'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                // Installs packages needed for the Vercel CLI
                bat 'npm install'
            }
        }

        stage('Parallel Deploy & Build') {
            parallel {
                stage('Deploy to Vercel') {
                    steps {
                        echo 'Deploying to Vercel...'
                        // Links the project and deploys to production
                        bat 'npx vercel link --project devops --yes --token=%VERCEL_TOKEN%'
                        bat 'npx vercel deploy --prod --yes --token=%VERCEL_TOKEN%'
                    }
                }

                stage('Docker Build & Push') {
                    steps {
                        script {
                            echo 'Building Docker Image...'
                            // Builds the image using the Dockerfile
                            bat "docker build -t %DOCKER_USER%/%IMAGE_NAME%:latest ."
                            
                            echo 'Login to Docker Hub...'
                            // Uses the credentials to login
                            withCredentials([usernamePassword(credentialsId: 'docker_hub_creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER_VAR')]) {
                                bat "docker login -u %DOCKER_USER_VAR% -p %DOCKER_PASS%"
                                
                                echo 'Pushing to Docker Hub...'
                                bat "docker push %DOCKER_USER%/%IMAGE_NAME%:latest"
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'GREAT SUCCESS: Website is live on Vercel and Image is on Docker Hub!'
        }
        failure {
            echo 'Something went wrong. Check the logs.'
        }
    }
}