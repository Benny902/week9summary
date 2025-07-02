
---

## Deployment Entry - 2025-07-02 15:47:01

**Public IP:** null  
**Region:** westeurope  
**VM Size:** Standard_B1ls  
**Image:** UbuntuServer 18.04-LTS

### Azure CLI Commands Used
- az login --use-device-code
- az group create --name devops-week9-rg --location westeurope
- az vm create --resource-group devops-week9-rg --name week9vm --image UbuntuServer 18.04-LTS --size Standard_B1ls ...
- az network public-ip update --allocation-method Static
- az vm open-port --port 22 ...
- scp ./ to VM
- docker-compose up -d

### Deployment Method
- GitHub Actions CI/CD (via deploy-vm.yml)

### Healthcheck
- curl http://null:3000

### Reboot Test
- App recovered after reboot

### Browser Compatibility
- Chrome
- Firefox
- Mobile

---

## Deployment Entry - 2025-07-02 17:05:07

**Public IP:** null  
**Region:** westeurope  
**VM Size:** Standard_B1ls  
**Image:** UbuntuServer 18.04-LTS

### Azure CLI Commands Used
- az login --use-device-code
- az group create --name devops-week9-rg --location westeurope
- az vm create --resource-group devops-week9-rg --name week9vm --image UbuntuServer 18.04-LTS --size Standard_B1ls ...
- az network public-ip update --allocation-method Static
- az vm open-port --port 22 ...
- scp ./ to VM
- docker-compose up -d

### Deployment Method
- GitHub Actions CI/CD (via deploy-vm.yml)

### Healthcheck
- curl http://null:3000

### Reboot Test
- App recovered after reboot

### Browser Compatibility
- Chrome
- Firefox
- Mobile
