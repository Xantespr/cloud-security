@description('Location for all resources - inherited from Resource Group')
param location string = resourceGroup().location

@description('Environment prefix (e.g., dev, prod)')
param env string = 'dev'

// uniqueString always the same short hash for a resource group.
var uniqueSuffix = uniqueString(resourceGroup().id)

// Łączymy przedrostek, środowisko i unikalny hash
var generatedWorkspaceName = 'law-${env}-${uniqueSuffix}'

// 1. Deploy SOC Core Infrastructure (LAW, Sentinel)
module socCore 'modules/core.bicep'= {
  name: 'deploy-soc-core'
  params: {
    location: location
    workspaceName: generatedWorkspaceName
  }
}

// 2. Deploy Honeytoken
module honeytoken 'modules/honeytoken.bicep'= {
  name: 'deploy-honeytoken'
  params: {
    location: location
    workspaceId: socCore.outputs.workspaceId // Dynamic dependency
  }
}
