pipeline {
  agent any
  environment {
    REPOSITORY_URI = "396913739303.dkr.ecr.us-east-2.amazonaws.com/jenkins"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    AWS_REGION = "us-east-2"
    K8S_NAMESPACE = "default"  // Cambia esto si estás usando un namespace diferente
    DEPLOYMENT_NAME = "miapp-deployment"  // Asegúrate de que el nombre del deployment sea correcto
    SERVICE_NAME = "miapp-service"  // Asegúrate de que el nombre del servicio sea correcto
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
        script {
          // Autenticación con ECR
          sh '''
            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
            docker build -t ${REPOSITORY_URI}:${IMAGE_TAG} .
            docker tag ${REPOSITORY_URI}:${IMAGE_TAG} ${REPOSITORY_URI}:latest
            docker push ${REPOSITORY_URI}:${IMAGE_TAG}
            docker push ${REPOSITORY_URI}:latest
          '''
        }
      }
    }
    stage('Deploy') {
      steps {
        script {
          // Actualización del deployment en Kubernetes
          sh '''
            kubectl set image deployment/${DEPLOYMENT_NAME} miapp=${REPOSITORY_URI}:${IMAGE_TAG} --namespace ${K8S_NAMESPACE} || \
            kubectl apply -f deployment.yaml --namespace ${K8S_NAMESPACE}
          '''
        }
      }
    }
    stage('Expose') {
      steps {
        script {
          // Exponer el servicio si no está expuesto
          sh '''
            kubectl apply -f service.yaml --namespace ${K8S_NAMESPACE}
          '''
        }
      }
    }
  }
  post {
    success {
      echo "Pipeline completado exitosamente."
      // Mostrar el estado del servic
