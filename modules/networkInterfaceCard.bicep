param id string
param nsgId string
param location string
param publicIP string
// Creating the NIC

resource nic 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: 'subNet1-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

output nicID string = nic.id
