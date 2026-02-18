// PARAMATERS
@description('List of subnets to create with address space \'10.0.0.0/16\'')
param subnets array

param overallNetwork string
param location string

// Create a virtual Network with subnets

// The 'VirtualNetwork' is a symbolicName that you are able to 
// reference later, this is the parent
resource VirtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: overallNetwork
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
  }
}

// Subnet creation
resource subnetsResource 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = [
  for subnet in subnets: {
    parent: VirtualNetwork
    name: subnet.name
    properties: { addressPrefix: subnet.prefix }
  }
]

// output of the actual ids of the subnets
output vnetID string = VirtualNetwork.id

// So here you are actually calling both the resource group and array.
// You can't do a for loop thorugh the resource group but you are able to 
// do it through the array since you already know that the resource group size
// is going to follow the array size.
output subnetIds array = [for i in range(0, length(subnets)): subnetsResource[i].id]

/*
Deploying the Virtual Network
- az login
- create resource group or use a predefined you already created
- az deployment group create --resource-group my-bicep-rg --template-file virtualNetwork.bicep --parameters <any parameters>
*/
