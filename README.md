# azureclidemo
* Demo Scripts (Provision Azure Resources using CLI)

## L2-A: Designing Azure Networking Solutions
- setup.sh
- vnetconfig.sh
- vnetcleanup.sh

## L2-B: Designing Azure VM Solutions
- setup.sh
- vmcreate.sh
- createvm.bicep

* Connect to VM using SSH (Authentication: password)
```
ssh azureuser@<Public_IP>
```

* Upload Website to VM using scp (Authentication: password)
```
scp -r <Website-dir> azureuser@<Public_IP>:
```

* Copy Website files to /var/www/html
```
ssh azureuser@<Public_IP>
cd <Website-dir>
sudo cp -R * /var/www/html/
```

