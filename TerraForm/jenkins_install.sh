#!/bin/bash
# --- Jenkins Installation Script for Ubuntu/Debian (using APT) ---

# 1. Update system packages
echo "Starting system update..."
sudo apt update -y

# 2. Install Java 17 (required for modern Jenkins versions)
echo "Installing Java 17 (OpenJDK)..."
# The 'default-jdk' package usually points to the latest supported version, but specifying 17 is safer.
sudo apt install -y openjdk-17-jdk

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