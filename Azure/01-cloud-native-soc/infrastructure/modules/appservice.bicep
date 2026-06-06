@description('Location for all resources - inherited from Resource Group')
param location string

@description('Environment prefix (e.g., dev, prod)')
param env string

@description('Log Analytics Workspace ID for Sentinel integration')
param logAnalyticsWorkspaceId string

@description('Frontend subnet ID for App Service VNet integration')
param frontendSubnetId string

@description('Name for the App Service')
param webAppName string = 'appsvc-soc-${env}-${uniqueString(resourceGroup().id)}'

// 1. Deploy App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: 'appServicePlan'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  properties: {
    reserved: true
  }
  kind: 'linux'
} 

// 2. Deploy Web App with VNet integration
resource webApp 'Microsoft.Web/sites@2025-03-01' = {
  name: webAppName
  location: location
  kind: 'app, linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|12.0'
      vnetRouteAllEnabled: true
    }
    virtualNetworkSubnetId: frontendSubnetId
  }
}

resource webAppDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'logs-to-law'
  scope: webApp
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output webAppUrl string = webApp.properties.defaultHostName
