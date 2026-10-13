
#!/bin/bash
set -euo pipefail

sudo dnf install -y wget

# Add the official Grafana RPM repository
sudo wget -q -O /tmp/grafana.gpg \
  https://rpm.grafana.com/gpg.key

sudo rpm --import /tmp/grafana.gpg

sudo tee /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=Grafana
baseurl=https://rpm.grafana.com
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
EOF

# Install Grafana OSS
sudo dnf install -y grafana

# Enable and start Grafana
sudo systemctl enable --now grafana-server

# Verify service
sudo systemctl is-active grafana-server
#sudo systemctl status grafana-server

echo "check for running"
echo "systemctl status grafana"
echo "curl http://localhost:3000"
echo "http://GRAFANA_PUBLIC_IP:3000"
