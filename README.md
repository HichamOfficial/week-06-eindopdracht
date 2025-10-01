# Week 06 Eindopdracht – Hybrid Cloud Deployment

Dit is de eindopdracht voor het vak **Infrastructure as Code (IAC)**.
De repository combineert alle onderdelen van de voorgaande weken in een volledig geautomatiseerde hybride cloud deployment.

Denk aan:

- **Terraform**
- **Cloud-init**
- **Ansible**
- **Docker / Docker Compose**
- **Inventories**
- **CI/CD (GitHub Actions)**

Het eindresultaat is een hybride omgeving waarin zowel lokale **ESXi VM’s** als **Azure VM’s** automatisch uitgerold en geconfigureerd worden, en waarin dezelfde applicatie zichtbaar is in de browser.

---

## Inhoudsopgave
- [Installatie](#-installatie)
- [Gebruik](#-gebruik)
- [Testen](#-testen)
- [Helperscripts](#-helper scripts)
- [Ontwikkelen & Richtlijnen](#-ontwikkelen--richtlijnen)
- [CI/CD](#-CI/CD)
- [Technische details](#-technische-details)
- [Documentatie](#-documentatie)
- [Licentie](#-licentie)

---

## Installatie

Je kunt de repository clonen op 2 manieren:

### 1.SSH
```bash
git clone git@github.com:"GEBRUIKERSNAAM"/week-06-eindopdracht.git
cd week-06-eindopdracht
```

### 2.HTTPS
```bash
git clone https://github.com/"GEBRUIKERSNAAM"/week-06-eindopdracht.git
cd week-06-eindopdracht
```


#### Initialiseer Terraform in zowel de ESXi- als Azure-map:
```bash
cd terraform/esxi && terraform init
cd ../azure && terraform init
```

---

## Gebruik

### Stap 1: ESXi en Azure VM’s uitrollen
```bash
cd terraform/esxi && terraform apply -auto-approve
cd ../azure && terraform apply -auto-approve
``` 
### Stap 2: Inventories updaten
Na elke deployment moeten de IP’s in de Ansible inventories komen:
```bash
./update_inventories.sh
cat ansible/inventories/all.ini
```

### Stap 3: Applicatie deployen met Ansible
```bash
ansible-playbook -i ansible/inventories/all.ini ansible/site.yml
``` 
Dit installeert Docker en start een nginx-container op alle VM’s (ESXi + Azure), inclusief een custom [index.html](ansible/files/index.html).

## Stap 3: SSH Keys

- SSH keys:
    ~/.ssh/terraform_keys (ESXi)
    ~/.ssh/azure_rsa (Azure)

---

## Testen
Valideer je code vóór deployment:

### Terraform
```bash
terraform validate
```

### Ansible
```bash
ansible-playbook --syntax-check ansible/site.yml
```

### YAML Lint
```bash
yamllint .
```
### Applicatie testen
Gebruik `curl` of de browser:
```bash
curl http://<ESXI_IP>      # Voor ESXi VM
curl http://<AZURE_IP>        # Voor Azure VM
```
In de browser verschijnt de custom [index.html](ansible/files/index.html).

---


## Helper scripts
Deze repo bevat handige scripts om sneller te werken:
- [update_inventories.sh](update_inventories.sh)
  Genereert automatisch ansible/inventories/esxi.ini, [azure.ini](ansible/inventories/azure.ini) en [all.ini](ansible/inventories/all.ini) op basis van Terraform output.
  Voegt ook automatisch fingerprints toe aan `known_hosts` zodat Ansible niet blijft hangen bij first-time SSH.
- [clean.sh](terraform/cleanup.sh)
  Verwijdert oude Terraform state en lock-bestanden. Handig bij foutmeldingen of voor een volledige herstart.


## Ontwikkelen & Richtlijnen

- **Branches**: gebruik conventional branches (`feat/..., bugfix/..., chore/...`)
- **Commits**: gebruik conventional commits (`feat: add ansible role for webserver`)
- **Codebeheer**: verwijder geen code; archiveer of breid uit
- **Best practices**: inventories gescheiden, [.gitignore](.gitignore) voorkomt Terraform state/caches

## CI/CD

Deze repository bevat een workflow in `.github/workflows/ci.yml`.
Bij elke push of pull request worden automatisch checks uitgevoerd:

- Terraform Validate (voor ESXi & Azure)
- Ansible syntax-check
- YAML linting (yamllint)
Zo wordt de codekwaliteit gewaarborgd vóórdat er gedeployed wordt.

---

## Technische details

- Terraform:
    - ESXi VM’s uitgerold via OVF en lokale datastore
    - Azure VM’s met publieke IP’s en SSH keys
    - Cloud-Init voor automatische user & key configuratie

- Cloud-Init:
    - Configuratie van `student` (Esxi) en `iac` (Azure) gebruikers
    - Toewijzing van SSH public keys
    - Installatie van open-vm-tools + Docker
    - Automatische group-toewijzing (docker)

- Ansible:
    - Docker installatie en opstarten
    - Deploy van nginx container met custom webpagina
    - Error-handling via block/rescue

- SSH Keys:
    - ~/.ssh/terraform_keys → ESXi
    - ~/.ssh/azure_rsa → Azure

---

## Documentatie
- **terraform/esxi/** → ESXi VM configuraties
- **terraform/azure/** → Azure VM configuraties
- **ansible/** → inventories, [`site.yml`](ansible/site.yml), en `files/index.html`
- **scripts/** → helper scripts zoals [update_inventories.sh](update_inventories.sh), [clean.sh](terraform/cleanup.sh)
- **README.md** → dit bestand
- **.github/workflows/ci.yml** → GitHub Actions workflow
- **LICENSE** → MIT-licentie

---

## Licentie

Dit project is gelicentieerd onder de MIT-licentie.
Zie [LICENSE](LICENSE) meer details.

