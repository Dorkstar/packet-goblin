#!/bin/bash
set -e

echo "👹 Packet Goblin Commander Installer"
echo "-----------------------------------"

# This was inspired by my friend Scot,
# he truly came up with the term "packet goblin"

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip curl
pip3 install --break-system-packages psutil paho-mqtt flask

# Make a folder
mkdir -p ~/packet-goblin
cd ~/packet-goblin

# Pull commander.py
curl -sO https://raw.githubusercontent.com/Dorkstar/packet-goblin/main/commander.py

# Create systemd service
SERVICE_FILE="/etc/systemd/system/commander.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Packet Goblin Commander
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/$USER/packet-goblin/commander.py
WorkingDirectory=/home/$USER/packet-goblin
Restart=always
User=$USER
Environment=MQTT_BROKER=localhost
Environment=MQTT_PORT=1883

[Install]
WantedBy=multi-user.target
EOF

# Enable & start
sudo systemctl daemon-reexec
sudo systemctl enable commander.service
sudo systemctl start commander.service

echo "✅ Commander running on port 5000"
echo "   Visit: http://<your-device-ip>:5000"
echo "   Logs: journalctl -u commander.service -f"
