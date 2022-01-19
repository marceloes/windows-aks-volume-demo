# Article: https://docs.microsoft.com/en-us/azure/aks/windows-container-cli

az login

$rg = "aks-volume-demo-rg"
$location = "southcentralus"
az group create --name $rg --location $location

$WINDOWS_USERNAME="adminuser"
$aks_cluster_name="aks-volume-cluster1"
az aks create `
    --resource-group $rg `
    --name $aks_cluster_name `
    --node-count 2 `
    --enable-addons monitoring `
    --generate-ssh-keys `
    --windows-admin-username $WINDOWS_USERNAME `
    --vm-set-type VirtualMachineScaleSets `
    --kubernetes-version 1.21.7 `
    --network-plugin azure

az aks nodepool add `
    --resource-group $rg `
    --cluster-name $aks_cluster_name `
    --os-type Windows `
    --name npwin `
    --node-count 1

az aks get-credentials --resource-group $rg --name $aks_cluster_name

# Create a volume with a size of 10GB
# Article: https://docs.microsoft.com/en-us/azure/aks/concepts-storage

# Deploy persistent volume claim
kubectl apply -f .\persistentvolclaim.yaml

# Deploy application
kubectl apply -f .\app.yaml

# Check application status
kubectl get pods

# Check volumes mapped in the pod
kubectl exec -it iiscorebox cmd.exe /C fsutil fsinfo drives

