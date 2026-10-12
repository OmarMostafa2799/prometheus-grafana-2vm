
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
  value = aws_instance.worker[*].private_ip
}
