
#!/bin/bash
set -euo pipefail

CONFIG="/etc/prometheus/prometheus.yml"



echo "==> Writing Prometheus configuration..."
cat > "$CONFIG" <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
        labels:
          instance: 'prometheus'

      - targets: ['10.20.0.11:9100']
        labels:
          instance: 'grafana'

      - targets: ['10.20.1.13:9100']
        labels:
          instance: 'worker-1'

      - targets: ['10.20.1.14:9100']
        labels:
          instance: 'worker-2'
EOF

echo "==> Validating configuration..."
/usr/local/bin/promtool check config "$CONFIG"

echo "==> Restarting Prometheus..."
systemctl restart prometheus

echo "==> Prometheus service status..."
systemctl status prometheus --no-pager



