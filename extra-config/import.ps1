# Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
# Connect-AzAccount

$rg = "auto-cleanup-rg"
$automationAccountName = "auto-cleanup-aa"
$runbookName = "auto-clean-resources"
# $scriptPath = ".\auto-cleanup.ps1" # works with runbookType: 'PowerShell'
$scheduleName = "daily 0100"

# Import-AzAutomationRunbook -Path $scriptPath -ResourceGroupName $rg -AutomationAccountName $automationAccountName -Name $runbookName -Type PowerShell -Force # works with runbookType: 'PowerShell'

Publish-AzAutomationRunbook -AutomationAccountName $automationAccountName -Name $runbookName -ResourceGroupName $rg

Register-AzAutomationScheduledRunbook -AutomationAccountName $automationAccountName -RunbookName $runbookName -ScheduleName $scheduleName -ResourceGroupName $rg


