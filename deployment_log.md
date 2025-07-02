
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

---

## Deployment Entry - 2025-07-02 18:30:54

**Public IP:** 20.224.96.1  
**Region:**   
**VM Size:**   
**Image:**  

### Infrastructure
- Provisioned via **Terraform** (modular setup)
  - Modules: , , 
  - Cloud-init script used for bootstrapping
  - VM auto-runs Docker Compose on startup

### Networking
- Static Public IP assigned
- NSG Rules configured:
  - Port 22 (SSH)
  - Port 3000 (Backend)
  - Port 4000 (Frontend)

### Application Deployment
- Microblog Backend: http://20.224.96.1:3000
- Microblog Frontend: http://20.224.96.1:4000
- Docker Compose used to deploy both services

### Azure CLI Commands Used
- az login --use-device-code
- az group create --name devops-week9-rg --location 
- az network public-ip update --allocation-method Static
- az vm create ... --image   --size  ...
- scp ./ to VM
- docker-compose up -d
- az network nsg rule create ...

### Deployment Method
- GitHub Actions CI/CD ()
- Auto-restart on reboot via cloud-init

### Healthcheck
- curl http://20.224.96.1:3000
- curl http://20.224.96.1:4000

### Reboot Test
- App recovered and served frontend/backend correctly

### Browser Compatibility
- Chrome
- Firefox
- Mobile

