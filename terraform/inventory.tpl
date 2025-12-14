[azure]
azurevm ansible_host=${azure_ip} ansible_user=Student ansible_ssh_private_key_file=~/.ssh/student

[esxi]
esxivm ansible_host=${esxi_ip} ansible_user=Student ansible_ssh_private_key_file=~/.ssh/student
