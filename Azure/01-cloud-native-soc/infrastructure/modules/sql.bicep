@description('Deployment location for all resources')
param location string

@description('Environment prefix from main (e.g., dev, prod)')
param env string

@description('Log Analytics Workspace ID for Sentinel integration, passed from main')
param logAnalyticsWorkspaceId string

@description('Frontend subnet ID for SQL Server VNet integration, passed from network module output')
param frontendSubnetId string

@secure()
@description('Admin password for SQL Server - stored as a secret in Key Vault')
param adminPassword string

var serverName = 'sql-soc-${env}-${uniqueString(resourceGroup().id)}'
var databaseName = 'sqldb-soc-${env}'


// 1. Deploy SQL Server
resource sqlServer 'Microsoft.Sql/servers@2025-01-01' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: adminPassword
    version: '12.0'
    publicNetworkAccess: 'Disabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

// 2. Deploy SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2025-01-01' = {
  name: databaseName
  parent: sqlServer
  location: location
    sku: {
      name: 'Basic'
      tier: 'Basic'
      capacity: 5
    }
}

// 3. Configure Diagnostic Settings to send SQL logs to Log Analytics
resource sqlServerAuditing 'Microsoft.Sql/servers/auditingSettings@2025-01-01' = {
  name: 'default'
  parent: sqlServer
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
  }
}

resource masterDb 'Microsoft.Sql/servers/databases@2025-01-01' existing = {
  parent: sqlServer
  name: 'master'
}

resource sqlDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'sql-to-law'
  scope: masterDb
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }
    ]
  }
}

// 4. Create VNet Rule to allow traffic from frontend subnet
resource  sqlVnetRule 'Microsoft.Sql/servers/virtualNetworkRules@2025-01-01' = {
  name: 'allow-frontend-subnet'
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: frontendSubnetId
    ignoreMissingVnetServiceEndpoint: true
  }
}
