param name string
param location string
param tags object

@description('Adds start time to schedules')
param utcShortValue string = utcNow('d')

var start01am = dateTimeAdd(utcShortValue, 'PT24H') // 01:00 AM

var schedule = [
    {
      name: 'daily 0100'    
        description: 'daily 0100'
        frequency: 'day'
        interval: 1
        startTime: start01am
        timeZone: 'Europe/Oslo'
    }  
]

resource automation_account 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: true
    publicNetworkAccess: true
    sku: {
      name: 'Basic'
    }
  }
}

resource automation_account_auto_remove_runbook 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  parent: automation_account
  location: location
  name: 'auto-clean-resources'
  properties: {
    logActivityTrace: 0
    logProgress: true
    logVerbose: true
    runbookType: 'PowerShell7' // here you can go with PowerShell and use the import.ps1 script. powershell7 gives more info from the runbook but then you need to add the script manually.
  }
}

resource symbolicname 'Microsoft.Automation/automationAccounts/schedules@2020-01-13-preview' = [for item in schedule: {
  name: item.name
  parent: automation_account
  properties: {
    description: item.description
    frequency: item.frequency
    interval: 1
    startTime: item.startTime
    timeZone: item.timeZone
  }
}]

output msiId string = automation_account.identity.principalId
