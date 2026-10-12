#!/bin/bash
set -euxo pipefail

dnf install -y curl tar gzip jq

# Create a dedicated system user
useradd --system \
  --no-create-home \
  --shell /sbin/nologin prometheus

mkdir -p /etc/prometheus /var/lib/prometheus

# Discover the latest official Prometheus release
VERSION=$(curl -fsSL \
  https://api.github.com/repos/prometheus/prometheus/releases/latest \
  | jq -r '.tag_name | ltrimstr("v")')

ARCHIVE="prometheus-${VERSION}.linux-amd64.tar.gz"
URL="https://github.com/prometheus/prometheus/releases/download/v${VERSION}/${ARCHIVE}"

cd /tmp
curl -fL "$URL" -o "$ARCHIVE"
tar -xzf "$ARCHIVE"

cd "prometheus-${VERSION}.linux-amd64"

install -m 0755 prometheus /usr/local/bin/prometheus
install -m 0755 promtool /usr/local/bin/promtool

install -m 0644 prometheus.yml /etc/prometheus/prometheus.yml

chown -R prometheus:prometheus \
  /etc/prometheus /var/lib/prometheus

# Configure Prometheus to monitor itself for now
cat > /etc/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']
EOF

chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create the systemd service
cat > /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus Monitoring Server
After=network-online.target
Wants=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.listen-address=0.0.0.0:9090
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now prometheus

systemctl is-active prometheus

echo "check for running"
echo "systemctl status prometheus"
echo "curl http://localhost:9090"
