output "webserver_ips" {
  value = esxi_guest.webservers[*].ip_address
}

output "dbserver_ip" {
  value = esxi_guest.dbserver.ip_address
}
