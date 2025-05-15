# PowerShell script for Kubernetes deployment

Write-Host "Starting deployment process..." -ForegroundColor Cyan

# Check if kubectl is installed
try {
    $kubectlVersion = kubectl version --client
    Write-Host "kubectl is installed" -ForegroundColor Green
} catch {
    Write-Host "Error: kubectl is not installed" -ForegroundColor Red
    exit 1
}

# Check if we can connect to the cluster
try {
    $clusterInfo = kubectl cluster-info
    Write-Host "Connected to Kubernetes cluster" -ForegroundColor Green
} catch {
    Write-Host "Error: Cannot connect to Kubernetes cluster" -ForegroundColor Red
    exit 1
}

# Create namespace
Write-Host "Creating namespace..." -ForegroundColor Cyan
try {
    kubectl apply -f k8s/namespace.yaml
    Write-Host "Namespace created successfully" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to create namespace" -ForegroundColor Red
    exit 1
}

# Create deployment
Write-Host "Creating deployment..." -ForegroundColor Cyan
try {
    kubectl apply -f k8s/deployment.yaml
    Write-Host "Deployment created successfully" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to create deployment" -ForegroundColor Red
    exit 1
}

# Create service
Write-Host "Creating service..." -ForegroundColor Cyan
try {
    kubectl apply -f k8s/service.yaml
    Write-Host "Service created successfully" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to create service" -ForegroundColor Red
    exit 1
}

# Wait for deployment to be ready
Write-Host "Waiting for deployment to be ready..." -ForegroundColor Cyan
try {
    kubectl rollout status deployment/cloud-app -n cloud-app --timeout=300s
    Write-Host "Deployment is ready" -ForegroundColor Green
} catch {
    Write-Host "Error: Deployment failed to become ready" -ForegroundColor Red
    exit 1
}

# Get service information
Write-Host "`nDeployment Status:" -ForegroundColor Cyan
kubectl get all -n cloud-app

Write-Host "`nService Information:" -ForegroundColor Cyan
kubectl get service cloud-app -n cloud-app

Write-Host "`nPod Logs:" -ForegroundColor Cyan
kubectl logs -l app=cloud-app -n cloud-app --tail=5 