targetScope = 'managementGroup'
param sub string = 'your subscription' // This is the subscription where the rg and automation account is deployed.
param location string = 'westeurope'

@description('Resource group name and where the automation account will be deployed')
param rgname string = 'auto-cleanup-rg'

@description('Adds time to tags')
param utctime string = utcNow('yyyyMMddTHHmm')

@description('Tags for the deployment')
param tags object = {
  deployment_tool: 'Bicep'
  updatedTime: utctime
}

@description('Automation account name')
param aaName string = 'auto-cleanup-aa'

@description('Subs where the automation account is granted contributor')
param subs array = [
'subscriptions where resources will be removed' // Sub where the automation account will remove resources
//  'add more subs if you have' //
//  'aaaaa-bbbb-1111-cccc-dddddd22222' // ######## example #######
]

module rg 'Modules/rg.bicep' = {
  scope: subscription(sub)
  name: rgname
  params: {
    location: location
    rgname: rgname
    tags: tags
  }
}

// ################################# Automation account creation begins here ####################################################
module aa 'Modules/automationAccount.bicep' = {
  name: '${deployment().name}-deployAutomationAccount'
  params: {
    name: aaName
    location: location
    tags: tags
  }
  scope: resourceGroup(sub,rgname)
  dependsOn: [
    rg
  ]
}

module subrbac 'Modules/rbac.bicep' = [for (item,i) in subs: {
  name: 'rbac-redploy${i}' 
  scope: subscription(item)
  params: {
    automation_accountspid: aa.outputs.msiId
    roleid: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
    sub: item
  }
}]


