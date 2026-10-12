
output "grafana_url" {
  value = "http://${aws_instance.grafana.public_ip}:3000"
}

output "grafana_public_ip" {
  value = aws_instance.grafana.public_ip
}

output "prometheus_private_ip" {
  value = aws_instance.prometheus.private_ip
}

output "worker_private_ips" {
  value = aws_instance.workers[*].private_ip
}


output "instance_ids" {
  value = {
    grafana     = aws_instance.grafana.id
    prometheus  = aws_instance.prometheus.id
    targets     = aws_instance.workers[*].id
  }
}
