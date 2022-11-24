# Connect to Azure with system-assigned managed identity

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()
 
# Write an information log with the current time.
Write-Output "PowerShell shows current TIME: $currentUTCtime"
 
$currentDate = Get-Date
$subscriptions = Get-AzSubscription
 
Foreach ($subscription in $subscriptions)
{
    Set-AzContext -Subscription $subscription
    $rgs= Get-AzResourceGroup
    Foreach ($rg in $rgs) {
        $tags = $rg.Tags
        if ($tags){
            if ($tags.Contains("DeletionDate")){
                $date = [datetime]$tags.item("DeletionDate")
                if ($date -lt $currentDate){
                    $rgname = $rg.ResourceGroupName
					Write-Output "Task Finished! Removed resource groups: ${rgname}"				
                    Remove-AzResourceGroup -Name $rgname -AsJob -Force					
                }
            }  
        }	             
    }
}
