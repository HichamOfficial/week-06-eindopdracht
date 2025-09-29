#!/usr/bin/env bash
set -e

# === PADEN NAAR BESTANDEN ===
AZURE_IP_FILE="terraform/azure/azure-ips.txt"
ESXI_IP_FILE="terraform/esxi/vm-ips.txt"

INV_DIR="ansible/inventories"
AZURE_INV="$INV_DIR/azure.ini"
ESXI_INV="$INV_DIR/esxi.ini"
ALL_INV="$INV_DIR/all.ini"

mkdir -p "$INV_DIR"

echo ">> Genereren van Azure inventory..."

# ----------------------
# Azure inventory
# ----------------------
echo "[azure]" > "$AZURE_INV"
# Pak alle IP's uit azure-ips.txt, sla eventuele [Azure] header over
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$AZURE_IP_FILE" | while read ip; do
  echo "$ip ansible_user=iac ansible_ssh_private_key_file=~/.ssh/azure_rsa" >> "$AZURE_INV"
done

echo ">> Genereren van ESXi inventory..."

# ----------------------
# ESXi inventory
# ----------------------
# Pak de eerste IP uit het bestand = Database Server
DB_IP=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$ESXI_IP_FILE" | head -n1)

echo "[db]" > "$ESXI_INV"
if [[ -n "$DB_IP" ]]; then
  echo "$DB_IP ansible_user=student ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> "$ESXI_INV"
fi

echo -e "\n[web]" >> "$ESXI_INV"
# Zoek alles NA "Webservers:" en verzamel IP's tot een lege regel/einde bestand
awk '/Webservers:/ {flag=1; next} /^$/ {flag=0} flag' "$ESXI_IP_FILE" \
  | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' \
  | while read ip; do
    echo "$ip ansible_user=student ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> "$ESXI_INV"
  done

echo ">> Combineren tot all.ini..."

# ----------------------
# All.ini (gecombineerd)
# ----------------------
cat "$ESXI_INV" > "$ALL_INV"
echo -e "\n[azure]" >> "$ALL_INV"
# sla de eerste lijn [azure] uit azure.ini niet over, want we willen [azure] sectie toevoegen
tail -n +2 "$AZURE_INV" >> "$ALL_INV"

echo "✅ Inventory bestanden bijgewerkt:"
echo "  - $AZURE_INV"
echo "  - $ESXI_INV"
echo "  - $ALL_INV"
