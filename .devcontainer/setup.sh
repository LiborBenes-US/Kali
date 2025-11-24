#!/bin/bash
set -e

echo "Installing 200+ bug bounty tools (one-time only)..."

sudo apt update -qq
sudo apt install -y \
    nmap masscan feroxbuster ffuf gobuster nikto whatweb wpscan sqlmap xsstrike arjun \
    subfinder amass assetfinder findomain dnsrecon httpx katana nuclei nuclei-templates \
    gau gf trufflehog secretfinder dalfox paramspider waybackurls gitjacker \
    recon-ng metasploit-framework exploitdb seclists dirb dirsearch wfuzz \
    chromium-browser zsh git curl wget jq bc tree htop unzip zip p7zip-full \
    python3-pip golang-go ruby-full php php-curl

# Go tools
export PATH=$PATH:$(go env GOPATH)/bin
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/ffuf/ffuf/v2@latest

# Python tools
pip3 install --break-system-packages uro arjun

# Zsh + OhMyZsh (optional but nice)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended || true
sed -i 's/robbyrussell/bira/g' ~/.zshrc

echo "All tools installed! Restart Codespace or run 'zsh' for cool shell."
