@description('Location for all resources - inherited from Resource Group')
param location string = resourceGroup().location

@description('uniqueString always the same short hash for a resource group.')
var uniqueSuffix = uniqueString(resourceGroup().id)

@description('Environment prefix (e.g., dev, prod)')
param env string = 'dev'

// 1. Deploy SOC Core Infrastructure (LAW, Sentinel)
module socCore 'modules/core.bicep'= {
  name: 'deploy-soc-core'
  params: {
    location: location
    env: env
    lawSuffix: uniqueSuffix
  }
}

// 2. Deploy Honeytoken
module honeytoken 'modules/keyvaultHoney.bicep'= {
  name: 'deploy-honeytoken'
  params: {
    location: location
    workspaceId: socCore.outputs.workspaceId // Dynamic dependency
  }
}

// 3. Deploy Network
module network 'modules/network.bicep' = {
  name: 'deploy-network'
  params: {
    location: location
    env: env
  }
}

// 4. Deploy operational keyVault for ops
module operationalKV 'modules/keyvault.bicep' = {
  name: 'deploy-operational-keyvault'
  params: {
    location: location
    env: env
    workspaceId: socCore.outputs.workspaceId // Dynamic dependency for diagnostics
  }
}
