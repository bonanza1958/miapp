pipeline {
  agent any
  environment {
    REPOSITORY_URI = "396913739303.dkr.ecr.us-east-2.amazonaws.com/jenkins"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    AWS_REGION = "us-east-2"
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/tuusuario/miapp.git', branch: 'main'
      }
    }
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }
    stage('Test') {
      steps {
        sh 'npm test'
      }
    }
    stage('Docker Build & Push') {
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
          docker build -t miapp .
          docker tag miapp:latest ${REPOSITORY_URI}:${IMAGE_TAG}
          docker push ${REPOSITORY_URI}:${IMAGE_TAG}
        '''
      }
    }
    stage('Deploy') {
      steps {
        sh '''
          kubectl set image deployment/miapp-deployment miapp=${REPOSITORY_URI}:${IMAGE_TAG} --namespace default || \
          kubectl apply -f deployment.yaml --namespace default
        '''
      }
    }
    stage('Expose') {
      steps {
        sh 'kubectl apply -f service.yaml --namespace default'
      }
    }
  }
  post {
    success {
      echo "Pipeline completado exitosamente."
      sh 'kubectl get svc miapp-service --namespace default'
    }
    failure {
      echo "El pipeline ha fallado."
    }
  }
}
