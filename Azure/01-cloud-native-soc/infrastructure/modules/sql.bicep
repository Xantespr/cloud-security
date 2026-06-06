@description('Deployment location for all resources')
param location string

@description('Unique suffix for resource naming to avoid collisions')
param env string

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
