@Library('Shared') _
pipeline {
    agent {label 'Node'}
    environment{
    DOCKER_FRONTEND_IMAGE_NAME = 'snehalpawar2945/wanderlust-frontend'
    DOCKER_BACKEND_IMAGE_NAME = 'snehalpawar2945/wanderlust-backend'
    DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
    GIT_BRANCH = "main"
    GITHUB_URL = "https://github.com/snehalpawar29/wanderlust-devops-automation.git"
    }
    stages{
        stage('Clean Workspace'){
            steps{
                script{
                    clean_ws()
                }
            }
        }
        stage('Clone'){
            steps{
                script{
                    clone(
                        branch: env.GIT_BRANCH,
                        url: env.GITHUB_URL
                    )
                }
            }
        }
        stage('Trivy Scan'){
            steps{
                script{
                    trivy_scan()
                }
            }
        }
        stage('OWASP'){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        stage('SonarQube Code Analysis'){
            steps{
                script{
                    sonarqube_analysis("SonarQube","wanderlust-devops-automation","wanderlust")
                }
            }
        }
        stage('SonarQube Code Quality Gates'){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }
        stage('Build Image'){
            parallel{
                stage('Build Frontend Image'){
                    steps{
                        script{
                            dir('wanderlust-devops-automation'){
                                docker_build(
                                    imageName: env.DOCKER_FRONTEND_IMAGE_NAME,
                                    imageTag: env.DOCKER_IMAGE_TAG,
                                    dockerfile: './frontend/Dockerfile',
                                    context: './frontend'
                                )
                            }
                        }
                    }
                }
                stage('Build Backend Image'){
                    steps{
                        script{
                            dir('wanderlust-devops-automation'){
                                docker_build(
                                    imageName: env.DOCKER_BACKEND_IMAGE_NAME,
                                    imageTag: env.DOCKER_IMAGE_TAG,
                                    dockerfile: './backend/Dockerfile',
                                    context: './backend'
                            )
                        }
                    }
                }
            }
        }
    }
        stage('Push Images to docker Hub'){
            parallel{
                stage('Push Frontend Image'){
                    steps{
                        script{
                            docker_push(
                                imageName: env.DOCKER_FRONTEND_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'Docker'
                            )
                        }
                    }
                }
                stage('Push Backend Image'){
                    steps{
                        script{
                            docker_push(
                                imageName: env.DOCKER_BACKEND_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'Docker'
                            )
                        }
                    }
                }
            }
    }
        stage('Update Kubernetes Manifest'){
            steps{
                script{
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'Github',
                        gitUserEmail: 'snehalpawar2945@gmail.com',
                        gitUserName: 'snehalpawar29'
                    )
                }
            }
        }
    }
    post{
        always{
            clean_ws()
        }
        success {
            script {
                emailext attachLog: true,
                from: 'sbpawar2904@gmail.com',
                subject: "Wanderlust Application has been updated and deployed - '${currentBuild.result}'",
                body: """
                    <html>
                    <body>
                        <div style="background-color: #FFA07A; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Project: ${env.JOB_NAME}</p>
                        </div>
                        <div style="background-color: #90EE90; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
                        </div>
                        <div style="background-color: #87CEEB; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">URL: ${env.BUILD_URL}</p>
                        </div>
                    </body>
                    </html>
            """,
            to: 'sbpawar2904@gmail.com',
            mimeType: 'text/html'
            }
        }
        failure {
            script {
                emailext attachLog: true,
                from: 'sbpawar2904@gmail.com',
                subject: "Wanderlust Application build failed - '${currentBuild.result}'",
                body: """
                    <html>
                    <body>
                        <div style="background-color: #FFA07A; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Project: ${env.JOB_NAME}</p>
                        </div>
                        <div style="background-color: #90EE90; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
                        </div>
                    </body>
                    </html>
            """,
            to: 'sbpawar2904@gmail.com',
            mimeType: 'text/html'
            }
        }
}
}