#!/bin/bash -e
on_chroot <<'EOF'
set -e
systemctl enable ssh
systemctl enable avahi-daemon
install -d -m 0755 /opt/mezo
cat > /opt/mezo/core.py <<'PY'
#!/usr/bin/env python3
import platform, shutil, socket, time
from datetime import datetime
def main():
    print("MEZO CORE online", flush=True)
    while True:
        _, _, free = shutil.disk_usage("/")
        temp = "n/a"
        try:
            with open("/sys/class/thermal/thermal_zone0/temp") as f:
                temp = f"{int(f.read().strip())/1000:.1f} C"
        except (OSError, ValueError):
            pass
        print(f"[{datetime.now().isoformat(timespec='seconds')}] host={socket.gethostname()} kernel={platform.release()} arch={platform.machine()} temp={temp} free={free//(1024**2)}MiB", flush=True)
        time.sleep(60)
if __name__ == "__main__":
    main()
PY
chmod 0755 /opt/mezo/core.py
cat > /etc/systemd/system/mezo-core.service <<'UNIT'
[Unit]
Description=MEZO CORE
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/mezo/core.py
Restart=on-failure
RestartSec=5
User=root
Environment=PYTHONUNBUFFERED=1
[Install]
WantedBy=multi-user.target
UNIT
systemctl enable mezo-core.service
EOF
