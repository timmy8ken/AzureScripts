# AzureScripts
PowerShell Scripts for managing Azure

## changeAzureVNETSubnet.ps1
this script will update the subnet of a Azure Virtual Machine as it can't be changed form the portal. The script has the following mandatory parameters
  * vm: the virtual machine name.
  * NICName: the name of the network interface card.
  * resourceGroup: the name of the resource group that the VM is a member of.
  * VNETName: the name of the virtual network the subnet is in.
  * newSubnetName: the name of the subnet that you want the machine to be in.
  
Idea for the script came from [Igor Pagliai - How to change Subnet and Virtual Network for Azure Virtual Machines (ASM & ARM)](https://blogs.msdn.microsoft.com/igorpag/2016/03/13/how-to-change-subnet-and-virtual-network-for-azure-virtual-machines-asm-arm/)
