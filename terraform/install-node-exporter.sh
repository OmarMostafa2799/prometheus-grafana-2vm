#!/bin/bash
set -euo pipefail

# Install dependencies
sudo dnf install -y curl tar

# Create Node Exporter user if it does not exist
id node_exporter >/dev/null 2>&1 || \
  sudo useradd --system --no-create-home \
  --shell /sbin/nologin node_exporter

# Get latest Node Exporter version
VERSION=$(curl -fsSL \
  https://api.github.com/repos/prometheus/node_exporter/releases/latest \
  | grep '"tag_name"' \
  | head -1 \
  | cut -d '"' -f 4 \
  | sed 's/^v//')

# Download and extract Node Exporter
cd /tmp

curl -fLO \
  "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz"

tar -xzf "node_exporter-${VERSION}.linux-amd64.tar.gz"

# Install binary
sudo install -m 0755 \
  "node_exporter-${VERSION}.linux-amd64/node_exporter" \
  /usr/local/bin/node_exporter

# Create systemd service
sudo tee /etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Prometheus Node Exporter
After=network-online.target
Wants=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9100
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl is-active node_exporter

# Verify service
sudo systemctl status node_exporter --no-pager

# Test metrics endpoint


# Test metrics endpoint
echo "Testing Node Exporter metrics..."

curl -fsS http://localhost:9100/metrics

echo "Node Exporter installation completed successfully."
