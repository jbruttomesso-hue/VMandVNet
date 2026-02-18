param location string

resource sshSecurity 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: 'sshSecurity'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          // lowest priority is 100 and highest is 4096
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output nsgId string = sshSecurity.id
