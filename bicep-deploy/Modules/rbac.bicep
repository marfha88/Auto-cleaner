targetScope = 'subscription'

param automation_accountspid string
param roleid string

param sub string

@description('This is the built-in Contributor role. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#virtual-machine-contributor')
resource roledefid 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription(sub)
  name: roleid
}

@description('Role assignment for Virtual Machine Contributor on Resource Group')
resource roleAssignment1 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().id, automation_accountspid, roledefid.id)
  properties: {
    roleDefinitionId: roledefid.id
    principalId: automation_accountspid
    principalType: 'ServicePrincipal'
  }
}
