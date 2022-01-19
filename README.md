# windows-aks-volume-demo
Demo of shared volume in windows containers in AKS

The idea is this demo is to show that one can have a Windows application, running in AKS in a Windows node and use a shared volume setup as an Azure Managed Disk.
</P>
It reuses the assets from the following articles:

- [Storage options for applications in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/concepts-storage)
- [Create a Windows Server container on an Azure Kubernetes Service (AKS) cluster using the Azure CLI](https://docs.microsoft.com/en-us/azure/aks/windows-container-cli)

To run, just run `setup.ps1` in Visual Studio Code PowerShell terminal or a PowerShell prompt.

Tip: I'd recommend you execute each step individually to better understand what's going on.
