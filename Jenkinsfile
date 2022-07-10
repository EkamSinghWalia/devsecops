def getDockerTag() {
 def tag = sh script: 'git rev-parse HEAD', returnStdout: true 
 return tag
}

pipeline {
  agent any 
  tools {
    maven 'maven'
  }
   environment {
          Docker_tag = getDockerTag()
      }
  stages {
    stage ('Initialize') {
      steps {
        sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
            ''' 
      }
    }
    
    stage ('Check-Git-Secrets') {
      steps {
        sh 'rm trufflehog || true'
        sh 'docker run gesellix/trufflehog --json https://github.com/EkamSinghWalia/devsecops.git > trufflehog'
        sh 'cat trufflehog'
      }
    }
    
     stage ('Source Composition Analysis') {
      steps {
         sh 'rm owasp* || true'
         sh 'wget "https://raw.githubusercontent.com/EkamSinghWalia/devsecops/master/owasp-dependency-check.sh" '
         sh 'chmod +x owasp-dependency-check.sh'
         sh 'bash owasp-dependency-check.sh'
         sh 'cat /var/lib/jenkins/OWASP-Dependency-Check/reports/dependency-check-report.xml'
        
      }
    }

     stage ('SAST') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'mvn sonar:sonar'
          sh 'cat target/sonar/report-task.txt'
        }
      }
    }


    
    stage ('Build') {
      steps {
      sh 'mvn clean package'
       }
    }
    stage ('Deploy-To-Tomcat') {
       steps {
       sshagent(['tomcat']) {
           sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@13.127.165.72:/opt/tomcat/webapps/webapp.war'
        }      
     }       
    }
    
   
    
      stage('DOCKER BUILD'){
	 steps {
	      script{
                sh 'docker build . -t devsecopsimage' 
        	sh 'docker container run -itd --name webserver -p 8888:8080 devsecopsimage'        
	      }
	 }
      }
   
	stage ('DAST') {
      	  steps {
        sshagent(['zap']) {
         sh 'ssh -o  StrictHostKeyChecking=no ubuntu@13.232.148.185 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://13.127.165.72:8080/webapp/" || true'
        }
      }
    }
    
  }
}
   


