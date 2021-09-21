#!/bin/bash
# V2Ray Proxy Installer
# Written by KsrvcO
# Compatible with Debian based operation systems
# Set same id for server and node
# In Server Side:
#    Change port number.
#    Change uuid number.
# In Node side:
#    Change Port number in inbounds
#    Change uuid number same as server side.
#    Change port number in outbounds that listening on server address.
#    Change address in outbounds that is server ip address.
if ! [ $(id -u) = 0 ]; then
     echo "You have not root privileges."
     exit 1
else
clear
echo -e "

Welcome to V2Ray Proxy Installer Wizard!

1. Install on Server
2. Install on any Node

"
read -p " Choose an option : " option
if [ $option == 1 ]
then
  mkdir v2ray-linux-temp-dir
  mkdir v2r
  mkdir -p /usr/local/etc/v2ray/
  apt install curl unzip zip unrar rar -y 2>/dev/null
  wget "https://github.com/ksrvco/V2Ray-Installer/archive/refs/heads/main.zip"
  unzip main.zip -d v2ray-linux-temp-dir/
  unzip v2ray-linux-temp-dir/V2Ray-Installer-main/v2ray-linux-64.zip -d v2r
  cp -r v2r/systemd/system/* /etc/systemd/system/
  cp -r v2r/v2ray /usr/local/bin/
  cp -r v2r/v2ctl /usr/local/bin/
  cp -r v2r/*.json /usr/local/etc/v2ray/
  cp -r v2r/*.dat /usr/local/etc/v2ray/
  echo -e '
 {
  "inbounds": [{
    "port": 1024,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "660752df-10fd-4383-b7b8-1bd86d1e6694",
          "level": 1,
          "alterId": 64
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }]
 }
  ' > /usr/local/etc/v2ray/config.json
  ln -s /etc/systemd/system/v2ray@.service
  ln -s /etc/systemd/system/v2ray.service
  systemctl enable v2ray.service
  systemctl start v2ray.service
  systemctl status v2ray.service
  rm -rf v2r 
  rm -rf v2ray-linux-temp-dir
  rm -rf main.zip
  rm -rf v2ray@.service
  rm -rf v2ray.service
elif [ $option == 2 ]
then
  mkdir v2ray-linux-temp-dir
  mkdir v2r
  mkdir -p /usr/local/etc/v2ray/
  apt install curl unzip zip unrar rar -y 2>/dev/null
  wget "https://github.com/ksrvco/V2Ray-Installer/archive/refs/heads/main.zip"
  unzip main.zip -d v2ray-linux-temp-dir/
  unzip v2ray-linux-temp-dir/V2Ray-Installer-main/v2ray-linux-64.zip -d v2r
  cp -r v2r/systemd/system/* /etc/systemd/system/
  cp -r v2r/v2ray /usr/local/bin/
  cp -r v2r/v2ctl /usr/local/bin/
  cp -r v2r/*.json /usr/local/etc/v2ray/
  cp -r v2r/*.dat /usr/local/etc/v2ray/
  echo -e '
{
  "inbounds": [{
    "port": 1080,
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "udp": true
    }
  }],
  "outbounds": [{
    "protocol": "vmess",
    "settings": {
      "vnext": [{
        "address": "192.168.252.144", 
        "port": 1024,  
        "users": [{ "id": "660752df-10fd-4383-b7b8-1bd86d1e6694" }]
      }]
    }
  },{
    "protocol": "freedom",
    "tag": "direct",
    "settings": {}
  }],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [{
      "type": "field",
      "ip": ["geoip:private"],
      "outboundTag": "direct"
    }]
  }
}
  ' > /usr/local/etc/v2ray/config.json
  ln -s /etc/systemd/system/v2ray@.service
  ln -s /etc/systemd/system/v2ray.service
  systemctl enable v2ray.service
  systemctl enable v2ray
  systemctl start v2ray.service
  systemctl status v2ray.service
  rm -rf v2r 
  rm -rf v2ray-linux-temp-dir
  rm -rf main.zip
  rm -rf v2ray@.service
  rm -rf v2ray.service
else
  echo "Wrong selection.Exiting..."
  exit
fi
fi
