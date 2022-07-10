pipeline {
  agent any 
  tools {
    maven 'maven'
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
           sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@3.110.184.18:/opt/tomcat/webapps/webapp.war'
        }      
     }       
    }
    
    stage('deploy'){
            agent any
            steps{
                sh label: '', script: '''rm -rf dockerimg
                    mkdir dockerimg
                    cd dockerimg
                    cp /var/lib/jenkins/workspace/hackwithme/target/WebApp.war .
                    touch dockerfile
                    cat <<EOT>>dockerfile
                    FROM tomcat
                    ADD gameoflife.war /usr/local/tomcat/webapps/
                    CMD ["catalina.sh", "run"]
                    EXPOSE 8080
                    EOT
                    sudo docker build -t webimage:$BUILD_NUMBER .
                    sudo docker container run -itd --name webserver$BUILD_NUMBER -p 8888:8080 webimage:$BUILD_NUMBER'''
            }
        }

    
   stage ('DAST') {
      steps {
        sshagent(['zap']) {
         sh 'ssh -o  StrictHostKeyChecking=no ubuntu@65.0.3.38 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://3.110.184.18:8080/webapp/" || true'
        }
      }
    }
    
  }
}
   


