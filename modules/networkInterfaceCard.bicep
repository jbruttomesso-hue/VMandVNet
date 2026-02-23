param id string
param nsgId string
param location string
param publicIP string
param nicModuleName string
param nicName string
// Creating the NIC

resource nic 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: nicModuleName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: nicName
        properties: {
          subnet: {
            id: id
          }
          // for now I will just do dynamic, but in the future I can make this flexible as well
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
