param location string

resource publicIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: 'myPublicIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output publicIP string = publicIP.id
