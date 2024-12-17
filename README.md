# Puppy Adoption Kubernetes Configuration

This repository contains Kubernetes configuration files for both development and production environments of the Puppy Adoption application.

## Prerequisites

- Minikube installed and running
- kubectl configured
- Docker Hub access (for pushing images)

## Common Commands

to start in production mode:

1. kubectl config set-context --current --namespace=production
2. minikube tunnel
3. access at http://puppy-adoption.local

to start in development mode:

1. kubectl config set-context --current --namespace=development

# Start port forwarding (run each in separate terminal)

2. kubectl port-forward service/backend-service 8181:8181
3. kubectl port-forward service/frontend-service 3000:3000

Frontend: http://localhost:3000
Backend: http://localhost:8181

# Switch namespace

kubectl config set-context --current --namespace=development
kubectl config set-context --current --namespace=production

# argoCD UI:

kubectl port-forward svc/argocd-server -n argocd 8080:443

### Cluster Information

```bash
# Get all running pods
kubectl get pods

# Get all services
kubectl get services

# Get deployments
kubectl get deployments

# Check pod logs
kubectl logs <pod-name>
kubectl logs deployment/frontend-deployment
kubectl logs deployment/backend-deployment

# Get detailed information about a resource
kubectl describe pod <pod-name>
kubectl describe service <service-name>
```

# Apply configurations

kubectl apply -f development/secrets/mongosecret.yaml
kubectl apply -f development/configmap.yaml
kubectl apply -f development/frontend/
kubectl apply -f development/backend/

# Apply configurations

kubectl apply -f production/secrets/mongosecret.yaml
kubectl apply -f production/configmap.yaml
kubectl apply -f production/frontend/
kubectl apply -f production/backend/
kubectl apply -f production/ingress.yaml

# Enable ingress (Minikube)

minikube addons enable ingress

# Get ingress address

kubectl get ingress

# Apply configurations

kubectl apply -f production/secrets/mongosecret.yaml
kubectl apply -f production/configmap.yaml
kubectl apply -f production/frontend/
kubectl apply -f production/backend/
kubectl apply -f production/ingress.yaml

# Enable ingress (Minikube)

minikube addons enable ingress

# Get ingress address

kubectl get ingress

# Create namespaces

kubectl create namespace development
kubectl create namespace production

# Restart deployments

kubectl rollout restart deployment frontend-deployment
kubectl rollout restart deployment backend-deployment

# Check pod logs with follow

kubectl logs -f <pod-name>

# Describe resources for troubleshooting

kubectl describe pod <pod-name>
kubectl describe service <service-name>
kubectl describe ingress <ingress-name>

# Delete resources if needed

kubectl delete deployment <deployment-name>
kubectl delete service <service-name>
kubectl delete pod <pod-name>
