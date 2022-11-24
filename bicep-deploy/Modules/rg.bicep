targetScope = 'subscription'

param location string
param rgname string
param tags object

@description('Resource Group for auto cleanup resources ')
resource cleanuprg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgname
  location: location
  tags: tags
}
