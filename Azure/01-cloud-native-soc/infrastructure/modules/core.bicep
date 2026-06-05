@description('Deployment location inherited from the main orchestrator')
param location string

@description('Name of the Log Analytics Workspace for SOC logs')
param workspaceName string

// 1. Deploy Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
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