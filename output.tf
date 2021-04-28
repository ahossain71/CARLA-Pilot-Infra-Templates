output "carla-pilot-postgresql_endpoint" {
    value = aws_db_instance.carla-pilot-postgresql.endpoint
}

#output "carla-pilot-instance_ids" {
#    value = [aws_instance.carla-pilot-.public_ip]
#}

#output "carla-pilot-dns_name" {
#    value = [aws_instance.carla-pilot-.dns_name]
#}

output "carla-pilot-lb_dns_name" {
  value = aws_lb.carla-pilot-lb.dns_name
}