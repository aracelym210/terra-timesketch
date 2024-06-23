#!/bin/bash
# author: aracelym, 2024

# ---- Install Docker engine ----
# https://docs.docker.com/engine/install/ubuntu/
echo "Installing docker engine..."
sudo apt-get update -yy
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Docker engine install complete"

# ---- Timeline install ----
# https://timesketch.org/guides/admin/install/
echo "Fetching timesketch install script"
curl -s -O https://raw.githubusercontent.com/google/timesketch/master/contrib/deploy_timesketch.sh
chmod 755 deploy_timesketch.sh
sudo mv deploy_timesketch.sh /opt
cd /opt
echo "Running timesketch install script..."
sudo ./deploy_timesketch.sh -y
cd /opt/timesketch
sudo docker compose up -d
echo "Timesketch is running..."

# CLI tool install
# https://timesketch.org/guides/user/cli-client/
echo "Installing Timesketch CLI tool..."
sudo apt install python3-pip -y
pip3 install timesketch-cli-client
echo "Done installing Timesketch CLI tool"

# ---- Plaso tools install ----
# https://plaso.readthedocs.io/en/latest/sources/user/Ubuntu-Packaged-Release.html
echo "Installing Plaso tools..."
echo | sudo add-apt-repository universe 
echo | sudo add-apt-repository ppa:gift/stable 
sudo apt-get update -y
sudo apt-get install plaso-tools -y
echo "Done."