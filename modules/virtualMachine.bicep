// Params
param location string
param vmModuleName string
param vmSize string
param computerName string
param adminUsername string
@secure()
param adminPassword string
param imagePublisher string
param imageOffer string
param imageSku string
param imageVersion string
param osDiskCreateOption string
param nicId string

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
        { id: nicId }
      ]
    }
  }
}
