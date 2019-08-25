output "clb_dns_name" {
  value       = module.webserver_cluster.clb_dns_name
  description = "The domain name of the load balancer"
}

output "db_address" {
  value       = module.mysql.db_address
  description = "The domain name of mysql"
}

output "db_port" {
  value       = module.mysql.db_port
  description = "The port of mysql"
}
