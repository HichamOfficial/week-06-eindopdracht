
resource "local_file" "vm_ips_file" {
  filename = "vm-ips.txt"
  content  = <<EOT
Database Server: ${esxi_guest.dbserver.ip_address}

Webservers:
%{ for ip in esxi_guest.webservers[*].ip_address ~}
- ${ip}
%{ endfor }
EOT

depends_on = [
    esxi_guest.webservers,
    esxi_guest.dbserver
  ]
}
