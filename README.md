# VMandVNet
Using Bicep, able to create a virtual network with a defined number of subnets, and in one of the subnets there is a VM.

Run "az deployment group create --resource-group <resource-group-name> --template-file tierTwoWebApp.bicep --parameters tierTwoWebApp.json"

Please remember to fill out the tierTwoWebApp.json to desired values for parameters.