@description('Location for all resources - inherited from Resource Group')
param location string = resourceGroup().location

@description('Environment prefix (e.g., dev, prod)')
param env string = 'dev'

// uniqueString tworzy zawsze taki sam, krótki hash dla tej konkretnej grupy zasobów.
var uniqueSuffix = uniqueString(resourceGroup().id)

// Łączymy przedrostek, środowisko i unikalny hash
var generatedWorkspaceName = 'law-${env}-${uniqueSuffix}'

// 1. Deploy SOC Core Infrastructure (LAW, Sentinel)
module socCore 'core.bicep' = {
  name: 'deploy-soc-core'
  params: {
    location: location
    workspaceName: generatedWorkspaceName
  }
}

// 2. Deploy Honeytoken
module honeytoken 'honeytoken.bicep' = {
  name: 'deploy-honeytoken'
  params: {
    location: location
    workspaceId: socCore.outputs.workspaceId // Dynamic dependency
  }
}
