@description('Location for all resources - inherited from Resource Group')
param location string

@description('Full Resource ID of the Log Analytics Workspace')
param workspaceId string

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

// Diagnostic Settings - send KeyVault logs to Log Analytics Workspace
resource kvDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: keyVault
  name: 'route-logs-to-law'
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'AuditEvent'
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
