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

echo "-> Provide github token"
read GITHUB_TOKEN
echo "-> Login to github"
curl -u "spysystem-user:${GITHUB_TOKEN}" -X POST -d "${DATA}" https://api.github.com/user/keys

echo "-> Add github to known hosts"
su spydev -c "ssh-keyscan -H github.com >> ~/.ssh/known_hosts"

echo "-> Provide branch"
echo "-> Leave empty for mysql57 branch"
read BRANCH

if [ -z "${BRANCH}" ]; then
  echo "-> Cloning mysql57 spy-install"
  su spydev -c "git clone --branch mysql57 git@github.com:spysystem/ServerInstallScript.git"
else
  echo "-> Cloning spy-install branch: ${BRANCH}"
  su spydev -c "git clone --branch ${BRANCH} git@github.com:spysystem/ServerInstallScript.git"
fi

echo "-> Run install"
ServerInstallScript/install.sh
