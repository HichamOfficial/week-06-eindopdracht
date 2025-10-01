#!/usr/bin/env bash

RG="rg-iac-se"
PREFIX="week-06"

# 1. VMs verwijderen
echo "Deleting VMs..."
az vm delete -g $RG -n ${PREFIX}-azurevm-1 --yes --no-wait
az vm delete -g $RG -n ${PREFIX}-azurevm-2 --yes --no-wait

# Even wachten tot detach klaar is
echo "Wachten 20 seconden zodat NIC's vrij komen..."
sleep 20

# 2. NICs verwijderen
echo "Deleting NICs..."
az network nic delete -g $RG -n ${PREFIX}-nic-1
az network nic delete -g $RG -n ${PREFIX}-nic-2

# 3. Public IPs verwijderen
echo "Deleting Public IPs..."
az network public-ip delete -g $RG -n ${PREFIX}-pip-1
az network public-ip delete -g $RG -n ${PREFIX}-pip-2

# 4. VNet + subnet verwijderen
echo "Deleting VNET..."
az network vnet delete -g $RG -n ${PREFIX}-vnet

# 5. SSH key verwijderen
echo "Deleting SSH Key..."
az sshkey delete -g $RG -n ${PREFIX}-skylab-key
