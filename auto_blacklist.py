import os
import requests

# Fetch malicious IPs from a public threat feed (example)
THREAT_FEED = "https://feodotracker.abuse.ch/downloads/ipblocklist.txt"

# Fetch the list of IPs
response = requests.get(THREAT_FEED)
malicious_ips = [ip.strip() for ip in response.text.splitlines() if ip and not ip.startswith("#")]

# Generate nftables rules
blacklist_rules = "\n".join([f"add element inet filter blacklist {{ {ip} }}" for ip in malicious_ips])

# Write the rules to blacklist.conf
with open("/etc/nftables/blacklist.conf", "w") as f:
    f.write(blacklist_rules)

# Apply the new rules
os.system("nft -f /etc/nftables.conf")

print("Blacklisted IPs added dynamically.")
