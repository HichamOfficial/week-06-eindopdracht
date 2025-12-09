# iac_week6_eindopdracht

Dit is de eindopdracht voor IAC (infrastructure as code). Deze repository voegt alle onderdelen van de voorgaande lessen samen in een compleet geautomatiseerde deployment van Portainer op zowel ESXI als Azure.

## Inhoudsopgave
- [iac\_week6\_eindopdracht](#iac_week6_eindopdracht)
  - [Inhoudsopgave](#inhoudsopgave)
  - [Installatie](#installatie)
  - [projectstructuur](#projectstructuur)
  - [Gebruik](#gebruik)
  - [Ontwikkelen](#ontwikkelen)
    - [prerequisites](#prerequisites)
    - [Richtlijnen](#richtlijnen)
  - [Testen](#testen)
  - [Licentie](#licentie)


## Installatie
1. Clone de repository:
met SSH: 
``` bash
git clone git@github.com:Joeyhofman/iac_week6_endopdracht.git
cd iac_week6_endopdracht
```

of met HTTPS
``` bash
git clone https://github.com/Joeyhofman/iac_week6_endopdracht.git
cd iac_week6_endopdracht
```
2. Terraform initialiseren
``` bash
cd terraform
terraform init
```

## projectstructuur
```
├── ansible [bevat alle Ansible code]
│   ├── playbooks [bevat de hoofd playbooks voor dpeloyment]
│   └── roles [bevat alle custom rollen die gebruikt worden door hoofd playbooks]
│       ├── docker [De docker role]
│       │   ├── defaults
│       │   ├── files
│       │   ├── handlers
│       │   ├── meta
│       │   ├── tasks
│       │   ├── templates
│       │   ├── tests
│       │   └── vars
│       └── portainer [De portainer role]
│           ├── defaults
│           ├── files
│           ├── handlers
│           ├── meta
│           ├── tasks
│           ├── templates
│           ├── tests
│           └── vars
└── terraform [Bevat alle Terraform code]
    ├── azure [Terraform module die de Azure omgeving opzet]
    └── esxi [Terraform module die de ESXI omgeving opzet]
```
## Gebruik
Om de VMs uit te rollen op ESXI en Azure gebruik (vanuit de root directory):
``` bash
cd terraform
terraform apply
```
Vervolgens kan de applicatie geinstalleerd worden door vanuit de root directory:
``` bash
cd ansible
ansible-playbook -i inventory.ini playbooks/deploy.yml
```

## Ontwikkelen

### prerequisites
- Ansible `2.18.8`
- OVF-tool `4.6.3`
- Azure CLi `2.77.0` (met ingelogde gebruiker (zie [Installeren Azure CLI](https://learn.microsoft.com/nl-nl/cli/azure/install-azure-cli?view=azure-cli-latest)))

### Richtlijnen
**branch conventie**: gebruik conventional branches (feat/branch_naam, chore/branch_naam, bugfix/branch_naam) 
**commitconventie**: gebruik conventional commits (bijv. chore: fixed typo in README.md) 
**testen**: test code voordat er gecommit wordt. Dit wordt ook door de pre-commit hook gedaan.


## Testen
Testen wordt op een aantal manier gedaan:
1. **terraform validate** valideert de terraform code:
``` bash
cd terraform
terraform validate
```
2. YAML lint:
 ``` bash
cd ansible
yamllint .
```
3. Ansible lint:
 ``` bash
cd ansible
ansible-lint playbooks/deploy.yml
```

## Licentie
Dit project is gelicentieerd onder <LICENTIE>. Zie [`LICENSE`](LICENSE).Test pipeline Sun Dec  7 22:56:58 CET 2025
Trigger Mon Dec  8 17:39:17 CET 2025
Trigger pipeline Tue Dec  9 15:04:20 CET 2025
# trigger Tue Dec  9 22:00:23 CET 2025
