#!/bin/bash
# --- Jenkins Installation Script for Ubuntu/Debian (using APT) ---

# 1. Update system packages
echo "Starting system update..."
sudo apt update -y

# 2. Install Java 17 (required for modern Jenkins versions)
echo "Installing Java 21 (OpenJDK)..."
# The 'default-jdk' package usually points to the latest supported version, but specifying 17 is safer.
sudo apt install -y openjdk-21-jdk

# 3. Install Jenkins Repository and Key
echo "Setting up Jenkins repository..."
# Add the key from the Jenkins project
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# Add the repository to the system's sources list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# 4. Update package lists again after adding the new repository
echo "Updating package list with Jenkins repository..."
sudo apt update -y

# 5. Install Jenkins
echo "Installing Jenkins package..."
# Jenkins will be installed as a systemd service automatically
sudo apt install jenkins -y

# 6. Start and Enable Jenkins service (usually done automatically on install)
echo "Ensuring Jenkins service is started and enabled..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 7. Wait for Jenkins to initialize (it can take 60-120 seconds)
echo "Waiting 60 seconds for Jenkins to start and generate the initial admin password."
sleep 60

# 8. Display the initial administrator password (Critical next step)
# This password is required to complete the setup via the web browser.
echo "------------------------------------------------------------------"
echo "Jenkins is installed and running!"
echo "You can access it on port 8080 (e.g., http://<your_vm_ip>:8080)."
echo "Here is the Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "------------------------------------------------------------------"
echo "Remember to open port 8080 in your firewall (e.g., using 'sudo ufw allow 8080')."

# Install Trivy
sudo apt-get install -y wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Install Docker
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
# timeout 60 
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ubuntu
sudo chmod 777 /var/run/docker.sock
# sudo newgrp docker
docker --version
