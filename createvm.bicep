// Variables
param resourceGroup string = 'MyResourceGroup'
param location string = 'australiaeast'
param vnetName string = 'MyVNet'
param subnetName string = 'MySubnet'
param nsgName string = 'MyNSG'
param vmName string = 'MyVM'
param vmImage string = 'UbuntuLTS'
param vmSize string = 'Standard_B1s'
param vmPublicIPName string = 'MyPublicIP'
param nicName string = 'MyVMNIC'
param htmlFilePath string = '/var/www/html/index.html'

// 1. Resource Group Creation
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroup
  location: location
}

// 2. Virtual Network (VNet) with Subnet
resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// 3. Network Security Group (NSG)
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTP'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          direction: 'Inbound'
          access: 'Allow'
          sourceAddressPrefixes: ['*']
          destinationPortRanges: ['80']
        }
      }
    ]
  }
}

// 4. Public IP Address
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: vmPublicIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    sku: {
      name: 'Basic'
    }
  }
}

// 5. Network Interface Card (NIC)
resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

// 6. Virtual Machine (VM)
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: vmImage
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'azureuser'
      adminPassword: '<your-password>'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// 7. Create the install-apache.sh script on the VM's home directory
resource installApacheScript 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = {
  name: '${vmName}/install-apache-script'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      script: './scripts/install-apache.sh'  // Script location on VM
    }
  }
}

// 8. Run the Apache installation script using Custom Script Extension
resource customScriptToVM 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = {
  name: '${vmName}/install-apache-script-run'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      script: '''
#!/bin/bash

# Update package list
sudo apt-get update

# Install Apache2
sudo apt-get install -y apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2

# Create an HTML file to serve from Apache
echo '<html><body><h1>Hello from my VM!</h1></body></html>' | sudo tee /var/www/html/index.html
'''
    }
  }
}

// Output the Public IP
output vmPublicIp string = publicIP.properties.ipAddress
