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
        stage('Stage Workspace'){
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
                                credentials: 'docker'
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
                                credentials: 'docker'
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
        }
    }