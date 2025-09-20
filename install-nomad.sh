#!/bin/bash
set -e

echo "👹 Packet Goblin Nomad Installer"
echo "--------------------------------"

# This was inspired by my friend Scot,
# he truly came up with the term "packet goblin"

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip curl
pip3 install --break-system-packages psutil paho-mqtt

# Make a folder
mkdir -p ~/packet-goblin
cd ~/packet-goblin

# Pull nomad.py
curl -sO https://raw.githubusercontent.com/Dorkstar/packet-goblin/main/nomad.py

# Prompt for Commander IP
read -p "Enter Commander IP (IP of SBC that will play role of commander): " CMD_IP

# Create systemd service
SERVICE_FILE="/etc/systemd/system/nomad.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Packet Goblin Nomad
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/$USER/packet-goblin/nomad.py
WorkingDirectory=/home/$USER/packet-goblin
Restart=always
User=$USER
Environment=MQTT_BROKER=$CMD_IP
Environment=MQTT_PORT=1883

[Install]
WantedBy=multi-user.target
EOF

# Enable & start
sudo systemctl daemon-reexec
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

echo "✅ Nomad installed and connected to Commander at $CMD_IP"
echo "   Logs: journalctl -u nomad.service -f"
