# All we are doing in this Script is just kickin off a vMotion operation
# Change the values for $myvCenter and $vCAdmin and make sure the "VM-to-Migrate" value of $vm is the name of the VM you are testing vMotion App Notification for

Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false
$myvCenter = "vCenter-Server-Name"
$vCAdmin = "VC-Admin-Login-Name"
# Set vCenter/ESXi credentials
$HostCred = $Host.UI.PromptForCredential("vCenter/ESXi credentials", "Enter ESXi Host or vCenter credentials for $myvCenter", "$vCAdmin", "")

#Connect to vCenter or ESXi Server indicated
Connect-viserver -Server $myvCenter -Credential $HostCred

# Define the virtual machine to be migrated
$vm = Get-VM -Name "VM-to-Migrate"

# Define the source and destination hosts
$sourceHost = $vm.VMHost
$destinationHost = Get-Cluster $sourceHost.Parent | Get-VMHost | Where-Object {$_.Name -ne $sourceHost.Name} | Get-Random

# Migrate the virtual machine to the destination host
Move-VM -VM $vm -Destination $destinationHost -Confirm:$false
