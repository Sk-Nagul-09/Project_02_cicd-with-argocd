pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'cloning from git'
                git 'https://github.com/Sk-Nagul-09/End-to-End-CICD-Project.git'
            }
        }
    
    
     
        stage('Sonarqube Scan') {
            steps {
                echo 'Scanning the code'
                sh 'ls -ltr'
                 sh '''
            mvn sonar:sonar \
                -Dsonar.host.url=http://54.172.246.180:9000 \
                -Dsonar.login=squ_2bce928d4643bc28ee6bef46366d4a1f27c2b955
        '''
         }
       }
    
    
   
        stage('Build Artifact') {
            steps {
                echo 'building the artifactory file'
                sh 'mvn clean package'
            }
        }
    
    
  
        stage('Build Docker Image') {
            steps {
                echo 'Build the docker image'
                sh 'docker build -t nagul09/cicd-e-t-end-pro:${BUILD_NUMBER} -f Dockerfile .'
            }
        }

        stage('Scanning the image') {
          steps {
            echo 'scanning the docker image'
            sh 'trivy image nagul09/cicd-e-t-end-pro:${BUILD_NUMBER}' 
          }
        }
    
    
     
        stage('push to dockerhub') {
            steps {
                echo 'push img to docker hub'
                script {
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                        sh 'docker login -u nagul09 -p ${dockerhub}'
    // some block 
    }
                sh 'docker push nagul09/cicd-e-t-end-pro:${BUILD_NUMBER}'
    
                }
                
            }
        }
    
    
    
    
    
    stage('Update Deployment File') { 
            environment { 
                GIT_REPO_NAME = "End-to-End-CICD-Project" 
                GIT_USER_NAME = "Sk-Nagul-09" 
            } 
            steps { 
                echo 'Update Deployment File' 
				
              
                withCredentials([string(credentialsId: 'githubtoken', variable: 'githubtoken')]) { 
                    sh ''' 
                        # Configure git user 
                        git config user.email "sknagul.awsdevops@gmail.com" 
                        git config user.name "Nagul" 
						
                        # Replace the tag in the deployment YAML file with the current buil  number 						
                        sed -i "s/cicd-e-t-end-pro:.*/cicd-e-t-end-pro:${BUILD_NUMBER}/g" deploymentfiles/deployment.yaml 
						
						
                        #Stage all changes 

                        git add . 
                        # Commit changes with a message containing the build number 
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}" 
                        #Push changes to the main branch of the GitHub repository 
                        git push https://${githubtoken}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main ''' 
                } 
            } 
        } 
         
    }
}
