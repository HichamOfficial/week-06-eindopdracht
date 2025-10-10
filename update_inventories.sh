#!/usr/bin/env bash
set -e

AZURE_IP_FILE="terraform/azure/azure-ips.txt"
ESXI_IP_FILE="terraform/esxi/vm-ips.txt"
ALL_INV="ansible/inventories/all.ini"

echo ">> Genereren van gecombineerd inventory..."
mkdir -p ansible/inventories

{
  echo "[all]"
  grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' $ESXI_IP_FILE | while read -r ip; do
    echo "$ip ansible_user=student ansible_ssh_private_key_file=~/.ssh/terraform_keys"
  done
  grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' $AZURE_IP_FILE | while read -r ip; do
    echo "$ip ansible_user=iac ansible_ssh_private_key_file=~/.ssh/azure_rsa"
  done
} > "$ALL_INV"

echo "Inventory gegenereerd: $ALL_INV"
