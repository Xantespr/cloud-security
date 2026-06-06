@description('Deployment location inherited from the main orchestrator')
param location string

@description('Unique suffix for resource naming to avoid collisions')
param lawSuffix string

@description('Environment prefix (e.g., dev, prod) inherited from main')
param env string

@description('dynamic name for our Log Analytics Workspace - combining prefix, env, and unique hash')
var generatedWorkspaceName = 'law-${env}-${lawSuffix}'

// 1. Deploy Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: generatedWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
  }
}

// 2. Onboard Microsoft Sentinel on top of the Workspace
resource sentinelOnboarding 'Microsoft.SecurityInsights/onboardingStates@2023-02-01' = {
  scope: logAnalyticsWorkspace
  name: 'default'
}

// 3. Outputs to pass data back to the orchestrator (main.bicep)
output workspaceId string = logAnalyticsWorkspace.id
output workspaceName string = logAnalyticsWorkspace.name
