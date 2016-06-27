#!/bin/bash

echo "-> Install git"
apt-get update && apt-get install -y git curl

echo "-> Generate SSH Key"
su spydev -c "ssh-keygen -t rsa -b 4096 -C \"$(hostname)@spysystem.dk\" -N \"\" -f /home/spydev/.ssh/id_rsa"

PUBLIC_KEY=`cat /home/spydev/.ssh/id_rsa.pub`

DATA=$(< <(cat <<EOF
{
  "title": "$(hostname).spysystem.dk",
  "key": "${PUBLIC_KEY}"
}
EOF
))

curl -u "spysystem-user" -X POST -d "${DATA}" https://api.github.com/user/keys

echo "-> Clone spy-install"
su spydev -c "git clone git@github.com:spysystem/ServerInstallScript.git"

echo "-> Run install"
ServerInstallScript/install.sh
