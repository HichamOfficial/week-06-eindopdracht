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

# ----------------------
# ESXi inventory
# ----------------------
echo ">> Genereren van ESXi inventory..."
DB_IP_ESXI=$(grep -A1 "Database Server" "$ESXI_IP_FILE" | tail -n1 | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
WEB_IPS_ESXI=$(awk '/Webservers:/ {flag=1; next} /^$/ {flag=0} flag' "$ESXI_IP_FILE" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

echo "[db]" > "$ESXI_INV"
if [[ -n "$DB_IP_ESXI" ]]; then
  echo "$DB_IP_ESXI ansible_user=student ansible_ssh_private_key_file=~/.ssh/terraform_keys" >> "$ESXI_INV"
fi

echo -e "\n[web]" >> "$ESXI_INV"
for ip in $WEB_IPS_ESXI; do
  echo "$ip ansible_user=student ansible_ssh_private_key_file=~/.ssh/terraform_keys" >> "$ESXI_INV"
done

# ----------------------
# Azure inventory
# ----------------------
echo ">> Genereren van Azure inventory..."
AZURE_IPS=$(awk '/Azure:/ {flag=1; next} /^$/ {flag=0} flag' "$AZURE_IP_FILE" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

echo "[azure]" > "$AZURE_INV"
for ip in $AZURE_IPS; do
  echo "$ip ansible_user=iac ansible_ssh_private_key_file=~/.ssh/azure_rsa" >> "$AZURE_INV"
done

# ----------------------
# All.ini combineren
# ----------------------
echo ">> Combineren tot all.ini..."
cat "$ESXI_INV" > "$ALL_INV"
echo >> "$ALL_INV"
cat "$AZURE_INV" >> "$ALL_INV"

echo "✅ Inventory bestanden bijgewerkt:"
echo "  - $ESXI_INV"
echo "  - $AZURE_INV"
echo "  - $ALL_INV"

# ----------------------
# Host keys automatisch accepteren
# ----------------------
echo ">> Hosts voorbereiden voor Ansible (fingerprints accepteren)..."

HOSTS=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$ALL_INV" | sort -u)

for host in $HOSTS; do
  # Oude keys verwijderen (anders dubbel)
  ssh-keygen -R $host >/dev/null 2>&1 || true

  # Nieuwe fingerprint ophalen
  ssh-keyscan -H $host >> ~/.ssh/known_hosts 2>/dev/null && \
    echo "   - $host"
done

echo "✅ Alle nieuwe hosts zijn toegevoegd aan known_hosts."