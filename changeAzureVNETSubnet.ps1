function change-AzureRmVnetSubnet {
    [cmdletbinding()]
        param(
            [Parameter(Mandatory=$true)]
            [string]$vm,

            [Parameter(Mandatory=$true)]
            [string]$NICName,

            [Parameter(Mandatory=$true)]
            [string]$resourceGroup,

            [Parameter(Mandatory=$true)]
            [string]$VNETName,

            [Parameter(Mandatory=$true)]
            [string]$newSubnetName
    
            )


        BEGIN {
            
            #Checking the Azure Login
            $needLogin = $true
            
            try {

                $context = Get-AzureRmContext
                if ($context) {

                    $needLogin = ([string]::IsNullOrEmpty($context.Account))

                }

            } catch {

                if ($_ -like "*Login-AzureRmAccount to login*") {

                    $needLogin = $true

                } else {

                    throw

                }

            }

            if ($needLogin) {

                Login-AzureRmAccount

            }

            

            Get-AzureRmSubscription
            $subscriptionName = read-host -Prompt "type the subscription name from the list above"

            try {
            
                Set-AzureRmContext -Subscription $subscriptionName -ErrorAction Stop

            } catch {

                write-error "Could not set the Azure Subscription. Error details: $($_.Exception.Message)"

            }

            Write-Output "You are now connecteed to the following Subscription"
            (Get-AzureRmContext).Subscription
        }
        
        
        PROCESS {

            Write-Output "Getting the Virtual Machine Details...."

            try {

                $virtualMachine = Get-AzureRmVM -ResourceGroupName $resourceGroup -Name $vm

            } catch {

                write-error "Could not find the Azure VM. Error details: $($_.Exception.Message)"

            }

            Write-Output "Getting the Network Interface details..."

            try {

                $NIC = Get-AzureRmNetworkInterface -Name $NICname -ResourceGroupName $resourceGroup

            } catch {

                write-error "Could not find the NIC details. Error details: $($_.Exception.Message)"

            }

            Write-Output "getting the virtual network details"

            try {

                $VNET = Get-AzureRmVirtualNetwork -Name $VNETname  -ResourceGroupName $resourceGroup

            } catch {

                write-error "Could not find the virtual network details. Error details: $($_.Exception.Message)"

            }

            Write-Output "getting the new subnet details"

            try {

                $newSubnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $newSubnetName

            } catch {



            }


        }

        END {

            Write-Warning "The subnet is about to be updated, this will take a few minutes and there will be a service interuption as the VM is moved to the new subnet"

            $NIC.IpConfigurations[0].Subnet.Id = $newSubnet.Id

            Set-AzureRmNetworkInterface -NetworkInterface $NIC

        }


}