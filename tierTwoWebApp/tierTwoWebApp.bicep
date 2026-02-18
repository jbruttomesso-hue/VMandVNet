// Dependency of the virtualNetwork.bicep, creates a vNet and two subnets
param location string = resourceGroup().location

// Idempotency is where if it is not created, create it, if created, then update if need to
// Params:
//  - overallNetwork: The network name
//  - location: the deployment location
//  - subnets: the list of subnets to create, space 10.0.0.0/16
module vNetModule '../modules/virtualNetwork.bicep' = {
  name: 'deployVnet'
  params: {
    subnets: [
      {
        name: 'subnet1'
        prefix: '10.0.0.0/24'
      }
      {
        name: 'subnet2'
        prefix: '10.0.1.0/24'
      }
    ]
    overallNetwork: 'myVnet'
    location: location
  }
}

module publicIP '../modules/publicIP.bicep' = {
  name: 'publicIP'
  params: {
    location: location
  }
}

// ^ this lets us access the outputs of the file we ran, 'virtualNetwork.bicep'

module nic '../modules/networkInterfaceCard.bicep' = {
  name: 'netInterfaceCard'
  params: {
    id: vNetModule.outputs.subnetIds[0]
    nsgId: sshSecurity.outputs.nsgId
    publicIP: publicIP.outputs.publicIP
    location: location
  }
}

module sshSecurity '../modules/networkSecurityGroup.bicep' = {
  name: 'deploySSHSecurity'
  params: {
    location: location
  }
}

// Now we are creating the VM

@secure()
// secure makes it so the password has to be:
// - 6-72 characters long
// - one uppercase character
// - one lowercase character
// - numeric digit
param adminPassword string
param adminUsername string = 'TEAuser'

resource vm1 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  // is the name you would see in the Azure portal
  name: 'vmOne'
  location: location
  properties: {
    hardwareProfile: { vmSize: 'Standard_B1s' }
    osProfile: {
      computerName: 'vm1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        { id: nic.outputs.nicID }
      ]
    }
  }
}
