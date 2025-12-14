#!/usr/bin/env bash
set -e

echo "Starting full Terraform destroy..."
echo "======================================"

# Ensure we are inside the terraform folder
cd "$(dirname "$0")"

echo "Running terraform init..."
terraform init -upgrade

echo ""
echo "Step 1: Destroy ESXi resources (module.esxi_app)..."
terraform destroy -auto-approve \
  -target=module.esxi_app

echo ""
echo "Step 2: Destroy Azure resources (module.azure_app)..."
terraform destroy -auto-approve \
  -target=module.azure_app

echo ""
echo "Step 3: Final full destroy (cleanup leftovers)..."
terraform destroy -auto-approve

echo ""
echo "Terraform destroy completed successfully!"
