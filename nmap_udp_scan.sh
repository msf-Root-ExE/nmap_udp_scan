#!/bin/bash

# Create new folder for scan outputs
mkdir scan_outputs_udp

cd scan_outputs_udp

# Prompt user for target IP or hostname
read -p "Enter target IP or hostname: " target

# Run Nmap ping sweep and output live hosts to txt file
echo "Running Nmap ping sweep on target $target..."
ping_sweep=$(sudo nmap -sn $target | grep 'Nmap scan report for' | cut -d ' ' -f 5)

# Check if any live hosts found
if [[ -z "$ping_sweep" ]]; then
    echo "No live hosts found."
    exit 0
fi

echo "Creating txt file with live hosts..."
echo $ping_sweep > live_hosts_udp.txt

# Perform verbose fast scan and output in all formats
echo "Running verbose fast scan on live hosts..."
sudo nmap -sU -Pn --top-ports 100 -iL live_hosts_udp.txt -oA fast_scan_udp

# Perform full scan including port 0 and output in all formats
echo "Running full scan including port 0 on live hosts..."
sudo nmap -sUV -Pn $target -oA full_scan_upd

echo "Scans complete."
