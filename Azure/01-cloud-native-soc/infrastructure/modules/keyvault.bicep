@description('Location for all resources - inherited from Resource Group')
param location string

@description('Environment prefix (e.g., dev, prod)')
param env string

var keyVaultName = 'kv-op-${env}-${uniqueString(resourceGroup().id)}'

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForTemplateDeployment: true
  }
} 
