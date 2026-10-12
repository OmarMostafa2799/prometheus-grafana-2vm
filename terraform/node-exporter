
#!/bin/bash
set -euxo pipefail
exec > >(tee -a /var/log/monitoring-setup.log) 2>&1

dnf install -y curl tar gzip jq

VERSION=$(curl -fsSL \
  https://api.github.com/repos/prometheus/node_exporter/releases/latest \
  | jq -r '.tag_name | ltrimstr("v")')

cd /tmp
curl -fL \
  "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz" \
  -o node-exporter.tar.gz

tar -xzf node-exporter.tar.gz

useradd --system --no-create-home \
  --shell /sbin/nologin node_exporter || true

install -m 0755 \
  "/tmp/node_exporter-${VERSION}.linux-amd64/node_exporter" \
  /usr/local/bin/node_exporter

cat >/etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Prometheus Node Exporter
After=network-online.target
Wants=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now node_exporter
systemctl is-active node_exporter
