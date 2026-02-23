param location string
param publicIPName string
param publicIPSKU string
param publicAllocationMethod string

resource publicIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPName
  location: location
  sku: {
    name: publicIPSKU
  }
  properties: {
    publicIPAllocationMethod: publicAllocationMethod
    dnsSettings: {
      domainNameLabel: publicIPName
    }
  }
}

output publicIP string = publicIP.id
