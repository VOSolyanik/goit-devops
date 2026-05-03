// Kubernetes agent + Kaniko + Git. Uses credential `github-token`.
// IRSA service account `jenkins-sa` provides ECR access.

pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: awscli
      image: amazon/aws-cli:2.15.0
      command:
        - /bin/sh
        - -c
        - sleep 360000
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.23.2-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
    - name: git
      image: alpine/git:latest
      command:
        - sleep
      args:
        - 99d
    - name: trivy
      image: aquasec/trivy:latest
      command:
        - sleep
      args:
        - 99d
    - name: bandit
      image: python:3.12-slim
      command:
        - sleep
      args:
        - 99d
  restartPolicy: Never
"""
    }
  }

  parameters {
    string(
      name: 'GIT_PUSH_BRANCH',
      defaultValue: 'main',
      description: 'Branch to push updated Helm values.'
    )
    string(
      name: 'HELM_VALUES_REPO_URL',
      defaultValue: '',
      description: 'HTTPS URL of repo containing the chart. Empty = this job workspace.'
    )
    string(
      name: 'HELM_CHART_PATH',
      defaultValue: 'charts/django-app',
      description: 'Path to chart directory (values.yaml inside).'
    )
    string(
      name: 'ECR_REPOSITORY_NAME',
      defaultValue: 'devops-final-project-ecr',
      description: 'ECR repository name (Terraform ecr_name).'
    )
    string(
      name: 'AWS_REGION',
      defaultValue: 'us-east-1',
      description: 'AWS region for ECR / STS.'
    )
    booleanParam(
      name: 'PUSH_HELM_VALUES',
      defaultValue: true,
      description: 'Commit and push values.yaml after ECR push.'
    )
  }

  environment {
    DOCKER_CONTEXT = 'django'
  }

  stages {
    stage('Checkout') {
      steps {
        container('git') {
          checkout scm
        }
      }
    }

    stage('SAST: Bandit (Python)') {
      steps {
        container('bandit') {
          sh '''
            pip install --quiet bandit
            bandit -r "${WORKSPACE}/${DOCKER_CONTEXT}" \
              --severity-level medium \
              --exit-zero \
              -f txt
          '''
        }
      }
    }

    stage('Security scan: Trivy') {
      steps {
        container('trivy') {
          sh '''
            trivy fs \
              --exit-code 0 \
              --severity HIGH,CRITICAL \
              --no-progress \
              "${WORKSPACE}/${DOCKER_CONTEXT}"

            trivy config \
              --exit-code 0 \
              --severity HIGH,CRITICAL \
              --no-progress \
              "${WORKSPACE}"
          '''
        }
      }
    }

    stage('Resolve ECR coordinates') {
      steps {
        container('awscli') {
          script {
            env.AWS_REGION = params.AWS_REGION
            env.AWS_ACCOUNT_ID = sh(
              script: 'aws sts get-caller-identity --query Account --output text',
              returnStdout: true
            ).trim()
            env.ECR_REGISTRY = "${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"
            env.IMAGE_REPOSITORY = "${env.ECR_REGISTRY}/${params.ECR_REPOSITORY_NAME}"
            env.IMAGE_TAG = "v1.0.${env.BUILD_NUMBER}"
          }
        }
      }
    }

    stage('Build and push image (Kaniko)') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context=dir://"${WORKSPACE}/${DOCKER_CONTEXT}" \
              --dockerfile="${WORKSPACE}/${DOCKER_CONTEXT}/Dockerfile" \
              --destination="${IMAGE_REPOSITORY}:${IMAGE_TAG}" \
              --cache=true
          '''
        }
      }
    }

    stage('Bump Helm values and push') {
      when {
        expression { return params.PUSH_HELM_VALUES }
      }
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PAT')]) {
            withEnv([
              "GIT_PUSH_BRANCH=${params.GIT_PUSH_BRANCH}",
              "HELM_CHART_PATH=${params.HELM_CHART_PATH}",
              "HELM_VALUES_REPO_URL=${params.HELM_VALUES_REPO_URL}",
            ]) {
              sh '''
                set -e
                git config --global --add safe.directory '*'

                if [ -n "${HELM_VALUES_REPO_URL}" ]; then
                  CLONE_DIR="/tmp/helm-values-${BUILD_NUMBER}"
                  rm -rf "${CLONE_DIR}"
                  REPO_HOSTPATH="${HELM_VALUES_REPO_URL#https://}"
                  REPO_HOSTPATH="${REPO_HOSTPATH#http://}"
                  git clone --branch "${GIT_PUSH_BRANCH}" --depth 1 \
                    "https://${GIT_USERNAME}:${GIT_PAT}@${REPO_HOSTPATH}" "${CLONE_DIR}"
                  REPO_ROOT="${CLONE_DIR}"
                else
                  REPO_ROOT="${WORKSPACE}"
                fi

                VALUES_FILE="${REPO_ROOT}/${HELM_CHART_PATH}/values.yaml"
                if [ ! -f "${VALUES_FILE}" ]; then
                  echo "Missing ${VALUES_FILE}"
                  exit 1
                fi

                sed -i.bak "s|^  repository:.*|  repository: ${IMAGE_REPOSITORY}|" "${VALUES_FILE}"
                sed -i.bak "s|^  tag:.*|  tag: \"${IMAGE_TAG}\"|" "${VALUES_FILE}"
                rm -f "${VALUES_FILE}.bak"

                cd "${REPO_ROOT}"
                git config user.email "jenkins-ci@local"
                git config user.name "Jenkins CI"

                git add "${HELM_CHART_PATH}/values.yaml"
                if git diff --staged --quiet; then
                  echo "No chart change to commit."
                  exit 0
                fi

                git commit -m "ci(django-app): ${IMAGE_REPOSITORY}:${IMAGE_TAG}"
                r="$(git remote get-url origin)"

                case "$r" in
                  https://github.com/*)
                    auth_r="https://${GIT_USERNAME}:${GIT_PAT}@${r#https://}"
                    ;;
                  git@github.com:*)
                    auth_r="https://${GIT_USERNAME}:${GIT_PAT}@github.com/${r#git@github.com:}"
                    ;;
                  *)
                    echo "Unsupported remote: $r"
                    exit 1
                    ;;
                esac

                git push "${auth_r}" "HEAD:${GIT_PUSH_BRANCH}"
              '''
            }
          }
        }
      }
    }
  }
}
