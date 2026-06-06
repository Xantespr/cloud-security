@description('Location for all resources')
param location string

@description('Environment prefix from main (e.g., dev, prod)')
param env string

@description('Network Name')
param vnetName string = 'vnet-soc-${env}'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: 'nsg-soc-default'
  location: location
  properties: {
    securityRules: [
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-frontend'
        properties: {
          addressPrefix: '10.0.10.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: 'subnet-backend'
        properties: {
          addressPrefix: '10.0.20.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output frontendSubnetId string = virtualNetwork.properties.subnets[0].id
output backendSubnetId string = virtualNetwork.properties.subnets[1].id
