// Dependency of the virtualNetwork.bicep, creates a vNet and two subnets
param location string = resourceGroup().location

// Needed Parameters: 
// - VNet: name (both external and internal), number of subnets, overallNetwork name
param networkModuleName string
param numOfSubnets int
param overallNetworkName string
param addressSpace string

// - publicIP: name (both external and internal)
param publicIPModuleName string

// - NIC: name (both external and internal)
param nicModuleName string

// - SSH security: name (both external and internal)
param sshSecurityModuleName string

// - VM: name (both external and internal), admin username, admin password, size,
// computer name, image reference (publisher, offer, sku, version), osDisk
param vmModuleName string
param vmSize string

// The default for the VM
/*
publisher: 'Canonical'
offer: '0001-com-ubuntu-server-jammy'
sku: '22_04-lts'
version: 'latest'
*/
param computerName string
param imagePublisher string
param imageOffer string
param imageSku string
param imageVersion string

// I want default to be 'FromImage'
param osDiskCreateOption string

@secure()
// secure makes it so the password has to be:
// - 6-72 characters long
// - one uppercase character
// - one lowercase character
// - numeric digit
param adminPassword string
param adminUsername string

// Idempotency is where if it is not created, create it, if created, then update if need to
// Params:
//  - overallNetwork: The network name
//  - location: the deployment location
//  - subnets: the list of subnets to create, space 10.0.0.0/16
var baseOctet = split(split(addressSpace, '/')[0], '.')
module vNetModule '../modules/virtualNetwork.bicep' = {
  name: networkModuleName
  params: {
    addressSpace: addressSpace
    subnets: [
      for i in range(0, numOfSubnets): {
        name: 'subnet${i + 1}'
        // in the future I can make this flexible, but for now just /24
        prefix: '${baseOctet[0]}.${baseOctet[1]}.${i}.0/24'
      }
    ]
    overallNetwork: overallNetworkName
    location: location
  }
}

param publicIPName string
param publicIPSKU string
param publicAllocationMethod string

module publicIP '../modules/publicIP.bicep' = {
  name: publicIPModuleName
  params: {
    location: location
    publicIPName: publicIPName
    publicIPSKU: publicIPSKU
    publicAllocationMethod: publicAllocationMethod
  }
}

// ^ this lets us access the outputs of the file we ran, 'virtualNetwork.bicep'

param nicName string

module nic '../modules/networkInterfaceCard.bicep' = {
  name: nicModuleName
  params: {
    id: vNetModule.outputs.subnetIds[0]
    nsgId: sshSecurity.outputs.nsgId
    publicIP: publicIP.outputs.publicIP
    location: location
    nicModuleName: nicModuleName
    nicName: nicName
  }
}

module sshSecurity '../modules/networkSecurityGroup.bicep' = {
  name: sshSecurityModuleName
  params: {
    location: location
  }
}

// Now we are creating the VM

resource vm1 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  // is the name you would see in the Azure portal
  name: vmModuleName
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
      osDisk: {
        createOption: osDiskCreateOption
      }
    }
    networkProfile: {
      networkInterfaces: [
        { id: nic.outputs.nicID }
      ]
    }
  }
}
