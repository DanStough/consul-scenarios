#! /bin/bash

apt update
apt install -y unzip curl jq dnsutils  # Useful stuff


curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=arm64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

mkdir /etc/consul.d
chmod a+w /etc/consul.d

apt install consul

# # Install Envoy (doesn't work for amd64)
# apt install -y apt-transport-https gnupg2 curl lsb-release
# curl -sL 'https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key' | sudo gpg --dearmor -o /usr/share/keyrings/getenvoy-keyring.gpg
# echo a077cb587a1b622e03aa4bf2f3689de14658a9497a9af2c427bba5f4cc3c4723 /usr/share/keyrings/getenvoy-keyring.gpg | sha256sum --check
# echo "deb [arch=arm64 signed-by=/usr/share/keyrings/getenvoy-keyring.gpg] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/getenvoy.list
# apt update
# apt install -y getenvoy-envoy
