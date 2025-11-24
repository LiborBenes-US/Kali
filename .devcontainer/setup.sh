#!/bin/bash
set -e

echo "Installing 200+ bug bounty tools (fixed for Ubuntu 24.04 - one-time only)..."

# Update and install apt-available tools
sudo apt update -qq
sudo apt install -y \
    nmap masscan dnsrecon sqlmap dirb dirsearch wfuzz whatweb nikto chromium-browser zsh git curl wget jq bc tree htop unzip zip p7zip-full \
    python3-pip golang-go ruby-full php php-curl golang git build-essential

# Add Kali repos for metasploit/exploitdb (safe for non-Kali Ubuntu)
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -
sudo apt update -qq
sudo apt install -y metasploit-framework exploitdb seclists

# Go tools (install to $GOPATH/bin)
export PATH=$PATH:$(go env GOPATH)/bin
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/owasp-amass/amass/v4/...@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/projectdiscovery/dalfox/v2/cmd/dalfox@latest
go install github.com/trufflesecurity/trufflehog@latest
go install github.com/haccer/subjack@latest  # For subdomain takeover

# Clone Git-based tools
git clone https://github.com/epi052/feroxbuster.git /tmp/feroxbuster && cd /tmp/feroxbuster && cargo install --path . && cd -
git clone https://github.com/wpscanteam/wpscan.git /tmp/wpscan && cd /tmp/wpscan && gem install bundler && bundle install && cd -
git clone https://github.com/lanmaster53/recon-ng.git /opt/recon-ng && cd /opt/recon-ng && pip3 install -r REQUIREMENTS
git clone https://github.com/m4ll0k/ParamSpider.git /opt/ParamSpider
git clone https://github.com/m4ll0k/GitHacker.git /opt/GitHacker
git clone https://github.com/m4ll0k/SecretFinder.git /opt/SecretFinder
git clone https://github.com/hahwul/dalfox.git /opt/dalfox  # Backup if go fails
git clone https://github.com/projectdiscovery/nuclei-templates.git /opt/nuclei-templates

# Python tools
pip3 install --break-system-packages requests arjun httpx-python xsstrike uro

# Fix paths for cloned tools
echo 'export PATH="$PATH:/opt/recon-ng/bin:/tmp/feroxbuster/target/release"' >> ~/.bashrc
echo 'export PATH="$PATH:/opt/ParamSpider:/opt/GitHacker:/opt/SecretFinder:/opt/dalfox"' >> ~/.bashrc
source ~/.bashrc

# Zsh + OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended || true
sed -i 's/robbyrussell/bira/g' ~/.zshrc

echo "All tools installed! Run 'source ~/.bashrc' or restart Codespace. Test: nmap --version"
