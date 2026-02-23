param location string
param networkSecurityGroupModuleName string
param networkSecurityGroupName string
param networkSecurityDirection string
param networkSecurityAccess string
param networkSecurityProtocol string
param networkSecuritySourcePortRange string
param networkSecurityDestinationPortRange string
param networkSecuritySourceAddressPrefix string
param networkSecurityDestinationAddressPrefix string

resource sshSecurity 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroupModuleName
  location: location
  properties: {
    securityRules: [
      {
        name: networkSecurityGroupName
        properties: {
          // lowest priority is 100 and highest is 4096
          priority: 1000
          direction: networkSecurityDirection
          access: networkSecurityAccess
          protocol: networkSecurityProtocol
          sourcePortRange: networkSecuritySourcePortRange
          destinationPortRange: networkSecurityDestinationPortRange
          sourceAddressPrefix: networkSecuritySourceAddressPrefix
          destinationAddressPrefix: networkSecurityDestinationAddressPrefix
        }
      }
    ]
  }
}

output nsgId string = sshSecurity.id
