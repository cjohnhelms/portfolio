pipeline {
    agent any

    environment { 
    NAME = "portfolio"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    }   
    stages {
        stage('Stop Existing') {
            steps {
                script {
                    echo 'First precheck...'
                    try {
                        sh 'docker stop ${NAME}'
                    } catch (err) {
                        echo "No running container to stop."
                    }
                }
            }
        }
        stage('Remove Existing') {
            steps {
                script {
                    echo 'Second precheck...'
                    try {
                        sh 'docker rm ${NAME}'
                    } catch (err) {
                        echo "No container to remove."
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                checkout poll: false, scm: scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/cjohnhelms/'${NAME}]])
                sh 'docker build -t docker.io/cjohnhelms/${NAME} .'
                sh 'docker tag docker.io/cjohnhelms/${NAME}:latest docker.io/cjohnhelms/${NAME}:${VERSION}'
            }
        }
        stage('Test') {
            steps {
                script {
                    echo 'Testing..'
                    sh 'docker run -d -p 8001:80 --name wifi docker.io/cjohnhelms/${NAME}:latest'
                    try {
                        sh 'curl 192.168.1.101:8001'
                    } catch (err) {
                        echo 'Container not running as expected'
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker login -u ${dockerHubUser} -p ${dockerHubPassword} docker.io'
                }
                sh 'docker push docker.io/cjohnhelms/${NAME}:${VERSION}'
                sh 'docker push docker.io/cjohnhelms/${NAME}:latest'
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    echo 'Prechecks...'
                    try {
                        sh 'docker stop '
                    } catch (err) {
                        echo "No running container to stop."
                    }
                    sh 'docker image prune -a -f'
                }
            }
        }   
    }
}
