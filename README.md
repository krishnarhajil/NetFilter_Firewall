# nft_Firewall
A Docker-based (containerized) firewall using nftables (Net Filter Tables).

## Project Overview
This project showcases a **Docker-based firewall** using `nftables` with advanced security features, including:
- *GeoIP filtering*.
- *DoS protection*.
- *SYN flood mitigation*.
- *Automated IP blacklisting*.  
- *Containerized environment*.

## Features and Functionalities
**GeoIP Filtering**
- Uses **GeoLite2** IP database to block traffic from specific countries.  
- In this project, **Russia** and **China** are blacklisted only for demonstration purposes.

**DoS Protection**
- Implements **rate limiting rules** to prevent brute force and DoS attacks.  
- Defends against **SSH attacks** by limiting connections per IP.  
- Helps reduce server overload and malicious exploitation attempts.

**SYN Flood Mitigation**
- Mitigates **SYN flood attacks** by limiting the number of half-open connections.  
- Prevents TCP connection table exhaustion.

**Automated IP Blacklisting**
- Dynamically fetches malicious IPs from public threat feeds.  
- Automates blacklisting by adding them to `nftables`.  
- **Python + Bash script** handles real-time updates.

## Prerequisites
Ensure you have the following installed on your system:
- Docker
- Docker Compose

## Setup Instructions
**Clone the Repository**
- First, clone the project repository:
```bash
git clone <your-repo-url>
cd nftables_project
```
- The Dockerfile already included the commands to install nftables and its dependencies.
- Go to MaxMind and log in or create a free account. Download the GeoLite2-Country database as .tar.gz.
- Extract and move the database into the project folder:
```bash
tar -xvzf GeoLite2-Country.tar.gz
move GeoLite2-Country.mmdb <path>
```
- Update the Dockerfile with the .mmdb file name or path if required.
- Run the following command to build the Docker image:
```bash
docker build -t nft_geo .
```
- Start the firewall container:
```bash
docker run --name geo_container -it --privileged nft_geo
```
- In case of encountering errors because folder structure inside the .tar.gz file may be different than expected, verify the internal structure of the .tar.gz file by extracting it manually. 
```bash
docker run --name geo_test -it --privileged ubuntu:22.04 /bin/bash
```

- Install tar inside the container (if not installed):
```bash
apt update && apt install -y tar
```
- Create the /usr/share/GeoIP/ directory inside the Docker image before moving the .mmdb file. Then copy the .tar.gz file into the running container. In a new terminal on your host machine, run:
```bash
docker cp GeoLite2-Country_20250321.tar.gz geo_test:/tmp/
```

- Extract the .tar.gz file inside the container and verify the folder structure:
```bash
cd /tmp
tar -xvzf GeoLite2-Country_20250321.tar.gz
ls -R /tmp
```
- Update the Dockerfile with the correct path of .mmdb and rebuild the image. Run the container.
- Access the container’s terminal and open the nftables.conf file in a text editor:
```bash
docker exec -it geo_container bash
```
```bash
nano /etc/nftables.conf
```
- Update or edit the file with the contents in the nftables_conf.txt file found in the repository. Write out and exit.
- Start the Python-based IP blacklisting script to enable automated IP-Blacklisting:
```bash
docker exec -it geo_container python3 /usr/local/bin/auto_blacklist.py
```
- The configuration of the firewall with the enlisted features have been done.
- Once you are done, stop the container:
```bash
docker stop geo_container
```


## Why Use Docker Instead of Running on the Host?
- Running the firewall inside a container **isolates it from the host system**, preventing accidental changes or security risks.
- Docker ensures the entire firewall setup can be easily **ported and replicated** on different machines without manual configuration.
- Docker makes it easy to **start, stop, and manage** the firewall with simple commands.  

## Use Cases
- This firewall can be used to protect personal servers by blocking foreign IPs and limiting DoS attempts.
- It can be deployed in small-scale production environments to add an extra layer of protection.
- Ideal for security labs and testing malicious traffic scenarios.

## Security Note
This is a personal project designed for educational and testing purposes. Use it cautiously and avoid running it on production systems without proper review.



