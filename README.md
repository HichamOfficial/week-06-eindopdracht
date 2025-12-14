# IAC Week 6 – Eindopdracht  
Volledig geautomatiseerde hybride deployment op **ESXi** en **Azure** met **Terraform + Ansible + GitHub Actions**.

Deze repository bevat alle code voor het bouwen van twee Ubuntu-VM’s (één op Azure, één op ESXi) en het automatisch configureren van Docker + Portainer via Ansible.  
De hele infrastructuur wordt uitgerold via **één Git push** dankzij de CI/CD workflow.

---

# Inhoudsopgave
- [Installatie](#installatie)
- [Projectstructuur](#projectstructuur)
- [Werking van de deployment pipeline](#werking-van-de-deployment-pipeline)
- [Gebruik (Automatisch)](#gebruik-automatisch)
- [Vereisten tijdens ontwikkeling](#vereisten-tijdens-ontwikkeling)
- [Ontwikkelrichtlijnen](#ontwikkelrichtlijnen)
- [Testen](#testen)
- [Licentie](#licentie)

---

# Installatie

## 1. Repository clonen

**SSH**
```bash
git clone git@github.com:HichamOfficial/week-06-eindopdracht.git
cd week-06-eindopdracht
```
**HTTPS**
```bash
git clone https://github.com/HichamOfficial/week-06-eindopdracht.git
cd week-06-eindopdracht
```
## 2. Secrets instellen (vereist voor de pipeline)
Ga in Github naar:
`Settings → Secrets → Actions → New repository secret`

Voeg toe:
| **Naam**                      | **Omschrijving**                       |
|-------------------------------|----------------------------------------|
| `AZURE_MNGMT_SUBSCRIPTION_ID` | Subscription ID voor Azure deployments |
| `ESXI_MNGMT_USER`             | ESXi login Username                    |
| `ESXI_MNGMT_PASSWORD`         | ESXi wachtwoord                        |
| `SSH_PUBLIC_KEY`              | SSH public key (Begin tot eind)        |
| `SSH_PRIVATE_KEY`             | SSH private key (Begin tot eind)       |

---

# Projectstructuur
```bash
week-06-eindopdracht/
├── .editorconfig
├── .github/
│   └── workflows/
│       └── deploy.yml
├── .gitignore
├── .yamllint.yml
├── ansible/
│   ├── .gitignore
│   ├── playbooks/
│   │   └── deploy.yml
│   └── roles/
│       ├── docker/
│       │   ├── defaults/
│       │   │   └── main.yml
│       │   ├── handlers/
│       │   │   └── main.yml
│       │   ├── meta/
│       │   │   └── main.yml
│       │   ├── tasks/
│       │   │   └── main.yml
│       │   ├── tests/
│       │   │   ├── inventory
│       │   │   └── test.yml
│       │   └── vars/
│       │       └── main.yml
│       └── portainer/
│           ├── defaults/
│           │   └── main.yml
│           ├── files/
│           │   └── docker-compose.yml
│           ├── handlers/
│           │   └── main.yml
│           ├── meta/
│           │   └── main.yml
│           ├── tasks/
│           │   └── main.yml
│           ├── tests/
│           │   ├── inventory
│           │   └── test.yml
│           └── vars/
│               └── main.yml
├── ansible.cfg
├── LICENSE
├── README.md
└── terraform/
    ├── .gitignore
    ├── azure/
    │   ├── main.tf
    │   ├── output.tf
    │   ├── userdata.yml
    │   └── variables.tf
    ├── destroy.sh
    ├── esxi/
    │   ├── main.tf
    │   ├── output.tf
    │   ├── userdata.yml
    │   └── variables.tf
    ├── inventory.tpl
    ├── main.tf
    ├── output.tf
    ├── provider.tf
    ├── test.txt
    └── variables.tf
```
---

# Werking van de Deployment Pipeline (GitHub Actions)
## _Automatische_ deployment bij een Git push
Zodra je een commit doet op `main` en pusht:
1. **Terraform wordt geformatteerd, gevalideerd en toegepast**
2. **VMs op Azure + ESXi worden aangemaakt**
3. **Terraform genereert automatisch `ansible/inventory.ini`**
4. **Na een korte wachtperiode wordt Ansible uitgevoerd**
5. **Ansible:**
    - Installeert Docker
    - Start Portainer
    - Zorgt dat beide VM's volledig klaar zijn
**Alles zonder handmatige stappen.**
Pipelinebestand staat in:
`.github/workflows/deploy.yml`

---

# Gebruik (Automatisch)
Er worden geen infrastructuur of configuratiestappen handmatig uitgevoerd.
Handmatig gebruik beperkt zich uitsluitend tot Git-handelingen.

## Wijzigingen doorvoeren en deployen
Elke wijziging in de infrastructuur of configuratie wordt automatisch uitgerold via de CI/CD-pipeline zodra deze naar de `main` branch wordt gepusht.

**Stappen:**
1. Pas code aan (Terraform / Ansible / workflow).
2. Voeg wijzigingen toe aan Git.
3. Commit en push naar `main`.
```bash
git add .
git commit -m "feat: update infrastructure configuration"
git push origin main
```
## Wat gebeurt er daarna automatisch?
Na de push start GitHub Actions automatisch de deployment pipeline:
- Terraform valideert en past de infrastructuur toe
- Azure en ESXi VM’s worden aangemaakt of bijgewerkt
- Terraform genereert het Ansible inventory bestand
- Ansible installeert en configureert Docker en Portainer
- De omgeving wordt volledig operationeel opgeleverd
**Er is geen handmatige login, SSH, Terraform apply of Ansible playbook nodig.**

---

# Deployment status bekijken
De voortgang en status van de deployment is te volgen via:
`GitHub → Actions → Deploy workflow`
Hier zijn alle stappen, logs en eventuele fouten inzichtelijk.

---

# Infrastructuur verwijderen
Indien nodig kan de infrastructuur worden verwijderd met het meegeleverde script:
```bash
cd terraform
./destroy.sh
```
Dit is de _enige_ handmatige uitzondering en wordt uitsluitend gebruikt voor opruimen of herdeployments.

---

# Vereisten tijdens ontwikkeling
## Prerequisites
- `Terraform` ≥ 1.4

   Gebruikt voor het provisionen van infrastructuur op Azure en ESXi.
- `Ansible` 2.18.8

   Voor configuratie van Docker en Portainer.
- `OVF Tool` 4.6.3

   Nodig voor ESXi VM-deployments.
- `Azure CLI` 2.77.0

   Vereist om Azure-resources te kunnen beheren.
    - De gebruiker moet lokaal ingelogd zijn (`az login`) tijdens ontwikkeling.
    
In productie worden deze tools niet lokaal gebruikt, maar volledig uitgevoerd binnen de CI/CD pipeline van GitHub Actions.

---

# Ontwikkelrichtlijnen
Om consistentie en traceerbaarheid te garanderen, worden de volgende richtlijnen gehanteerd:

## Branch conventies
Gebruik conventional branches:
- `feat/<naam>` – nieuwe functionaliteit
- `chore/<naam>` – onderhoud, documentatie
- `bugfix/<naam>` – fixes

## Commit conventies
Gebruik `conventional commits`, bijvoorbeeld:
```bash
feat: add portainer deployment
chore: update README
bugfix: fix terraform variable typo
```
## Testen vóór commit
- Code wordt lokaal getest vóór commit
- De pipeline voert aanvullende validaties automatisch uit
- Fouten blokkeren de deployment

---

# Testen
De kwaliteit van de code wordt zowel lokaal als automatisch in de pipeline gecontroleerd.

## Terraform validatie 
Controleert de syntaxis en logica van Terraform configuraties:
```bash
cd terraform
terraform validate
```
## YAML lint
Controleert YAML-bestanden (Ansible, workflows):
```bash
cd ansible
yamllint .
```
## Ansible lint
Controleert Ansible playbooks en rollen:
```bash
cd ansible
ansible-lint playbooks/deploy.yml
```
Deze checks worden ook automatisch uitgevoerd binnen GitHub Actions.

---

# Licentie
Dit project is gelicentieerd onder de meegeleverde licentie.
Zie het bestand [LICENSE](LICENSE) voor volledige details.
