# windows-aks-volume-demo
Demo of shared volume in windows containers in AKS

The idea is this demo is to show that one can have a Windows application, running in AKS in a Windows node and use a shared volume setup as an Azure Managed Disk.
The application is a simple IIS core server and all it does it mount the volumes created.

Each volume mounted showcases one type of shared volume that can be used:
- E: drive -> Dynamically created Azure Managed Disk
- F: drive -> Dynamically created Azure File Share
- G: drive -> Existing Azure File Share mounted as a volume
- H: drive -> Existing Azure Managed Disk mounted as a volume

It reuses the assets from the following articles:

- [Storage options for applications in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/concepts-storage)
- [Create a Windows Server container on an Azure Kubernetes Service (AKS) cluster using the Azure CLI](https://docs.microsoft.com/en-us/azure/aks/windows-container-cli)
- [Manually create and use a volume with Azure Files share in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-files-volume)
- [Dynamically create and use a persistent volume with Azure disks in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-disks-dynamic-pv)
- [Manually create and use a volume with Azure disks in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-disk-volume)
- [Persistent Volume Management and Expansion in Kubernetes with Azure Kubernetes Service](https://thecloudblog.net/post/persistent-volume-management-and-expansion-in-kubernetes-with-azure-kubernetes-service/)
- [AZ CLI Reference](https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest)
- [Create an AKS cluster with managed identities](https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#create-an-aks-cluster-with-managed-identities)


To run, just run `setup.ps1` in Visual Studio Code PowerShell terminal or a PowerShell prompt.

**Tip**: I'd recommend you execute each step individually to better understand what's going on.

**Note**: This demo is not intended to be a production-ready demo. It is just a demo to show how to use the Azure Kubernetes Service (AKS) to deploy a Windows application.

**Note**: I used az aks update to enable managed identity for the cluster since I already had that created. You could just add the switch to the az aks create command.
