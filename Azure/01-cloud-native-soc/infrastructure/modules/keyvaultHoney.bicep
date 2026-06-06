@description('Deployment location')
param location string

@description('Full Resource ID of the Log Analytics Workspace')
param workspaceId string

// Dynamic generated name of our keyVault
var keyVaultName = 'kv-GAdmin-${uniqueString(resourceGroup().id)}'

// 1. KayVault
resource honeyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // no one should have access there
  }
}

// 2. Diagnostic Settings
resource kvDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: honeyVault
  name: 'route-logs-to-law'
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
      }
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: false
      }
    ]
  }
}
