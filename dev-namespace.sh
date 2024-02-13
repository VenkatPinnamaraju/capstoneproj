#!/bin/bash

# Azure service principal credentials
SP_APP_ID="990b7bfc-6f00-48b1-941e-58476eeaf976"
SP_PASSWORD="iJO8Q~yxUiuOuM1uRUq3ZYQWb1Mh9ifh3fRhicAw"
TENANT_ID="104e77d4-81e7-4c16-ab44-935220bed6dd"

# Azure AKS details
AKS_RESOURCE_GROUP="ven-aks-rg-dev"
AKS_CLUSTER_NAME="ven-aks-dev"

# Define the namespace
NAMESPACE="dev"

# Login to Azure using service principal
az login --service-principal -u "$SP_APP_ID" -p "$SP_PASSWORD" --tenant "$TENANT_ID"

# Set the context to the AKS cluster
az aks get-credentials --resource-group "$AKS_RESOURCE_GROUP" --name "$AKS_CLUSTER_NAME"

# Check if the namespace already exists
if kubectl get namespace "dev" &> /dev/null; then
    echo "Namespace 'dev' already exists."
else
    # Create the namespace
    kubectl create namespace "dev"
    echo "Namespace 'dev' created successfully."
fi
