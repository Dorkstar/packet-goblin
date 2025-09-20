# packet-goblin
👹 Packet Goblin — lightweight fleet monitoring & command system using MQTT + Flask. Runs Nomad agents on SBCs and the Commander dashboard for control.


# 👹 Packet Goblin

Packet Goblin is a lightweight fleet monitoring and remote command tool built on **MQTT + Flask**.  
It was designed for small labs, home servers, and SBC fleets (Raspberry Pi, Orange Pi, RockPi, etc.),  
to keep an eye on system metrics and send commands remotely.

> 📝 **Trivia**: This project was inspired by my friend **Scot**,  
> who truly came up with the term *"packet goblin."* 👹

---

##  Components

- **Nomad**: lightweight agent that runs on each device.  
  Publishes system metrics (CPU, RAM, uptime, temps, network info) to MQTT.  

- **Commander**: the central dashboard.  
  A Flask web app that subscribes to metrics, shows them live,  
  and allows sending remote commands back to Nomads.

---

##  Quick Install

### Install a Nomad (agent)
```bash
curl -sSL https://raw.githubusercontent.com/Dorkstar/packet-goblin/main/install-nomad.sh | bash

Will prompt for your Commander’s IP (Tailscale IP).

Registers as a systemd service so it runs on boot.

Check logs with:
journalctl -u nomad.service -f

Install a Commander (dashboard)
Runs a web dashboard on port 5000.

View at:
http://<commander-ip>:5000
Check logs with:
journalctl -u commander.service -f

Features

Collects system info: CPU, RAM, disk, uptime, network, processes

Detects device online/offline state

Remote command execution (e.g., uname -a)

Tailscale-friendly (works over private mesh VPNs)

Auto-starts via systemd

Uninstall

If you need to remove Packet Goblin:
# For Nomad
sudo systemctl disable --now nomad.service
sudo rm /etc/systemd/system/nomad.service
rm -rf ~/packet-goblin

# For Commander
sudo systemctl disable --now commander.service
sudo rm /etc/systemd/system/commander.service
rm -rf ~/packet-goblin

👹 Packet Goblin eats metrics so you don’t have to.

