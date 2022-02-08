# Article: https://docs.microsoft.com/en-us/azure/aks/windows-container-cli

az login

$rg = "aks-volume-demo-rg"
$location = "southcentralus"
az group create --name $rg --location $location

# Set up demo cluster
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
    --network-plugin azure `
    --enable-managed-identity

az aks nodepool add `
    --resource-group $rg `
    --cluster-name $aks_cluster_name `
    --os-type Windows `
    --name npwin `
    --node-count 1

# az aks update --name $aks_cluster_name --resource-group $rg --enable-managed-identity

az aks get-credentials --resource-group $rg --name $aks_cluster_name

# Create a azure file share in the same resource group as the cluster
$share_name = "aks-volume-demo-share"
$storage_account_name = "aksfilesharedemosa"
az storage account create --resource-group $rg `
                          --name $storage_account_name `
                          --location $location `
                          --sku Standard_LRS `
                          --kind StorageV2 `
                          --query id `
                          -o tsv
$storage_connection_string=$(az storage account show-connection-string --resource-group $rg --name $storage_account_name -o tsv)                                                           
az storage share create --name $share_name --connection-string $storage_connection_string
$storage_key=$(az storage account keys list --resource-group $rg --account-name $storage_account_name --query [0].value -o tsv)

# Store storage key as secret in the cluster
$storage_key_secret_name = "aks-volume-demo-storage-key"
kubectl create secret generic $storage_key_secret_name --from-literal=azurestorageaccountname=$storage_account_name --from-literal=azurestorageaccountkey=$storage_key

# Create a managed disk in the same resource group as the cluster
$disk_name = "aks-volume-demo-disk"
$disk_size = "10"
$disk_resource_id = $(az disk create --resource-group $rg --name $disk_name --size-gb $disk_size -o tsv --query id)

# Grant access to the existing disk for the cluster identity 
$identity = $(az aks show --name $aks_cluster_name --resource-group $rg --query "identity.principalId" -o tsv)
az role assignment create --role "Storage Account Contributor" `
    --assignee $identity `
    --scope $disk_resource_id 

# Dyamically create disk volumes ans file shares
kubectl apply -f .\dynamic-disk-pv-claim.yaml
kubectl apply -f .\dynamic-share-pv-claim.yaml

# Use statically created disk volumes
kubectl apply -f .\existing-disk-storageclass.yaml
kubectl apply -f .\existing-disk-pv.yaml
kubectl apply -f .\existing-disk-pv-claim.yaml

# Use statically created file shares
kubectl apply -f .\existing-share-pv.yaml
kubectl apply -f .\existing-share-pv-claim.yaml

# Deploy application
kubectl apply -f .\app.yaml
kubectl delete -f .\app.yaml

# Check application status (it may take a while to start up)
kubectl describe pod iiscorebox
kubectl get pods

# Check volumes mapped in the pod
kubectl exec -it iiscorebox cmd.exe /C fsutil fsinfo drives
kubectl exec -it iiscorebox cmd.exe /C dir C:\windows
kubectl exec -it iiscorebox cmd.exe /C copy c:\windows\win.ini h:\
kubectl exec -it iiscorebox cmd.exe /C dir h:\

