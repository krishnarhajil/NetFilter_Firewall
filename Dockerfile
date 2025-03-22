# Base image
FROM ubuntu:22.04  

# Install required tools
RUN apt update && apt install -y nftables iproute2 iputils-ping curl vim libmaxminddb0 libmaxminddb-dev mmdb-bin

# Create the GeoIP directory
RUN mkdir -p /usr/share/GeoIP

# Copy and extract the GeoLite2 DB
COPY GeoLite2-Country_20250321.tar.gz /tmp/
RUN tar -xvzf /tmp/GeoLite2-Country_20250321.tar.gz -C /tmp/ \
    && mv /tmp/GeoLite2-Country_20250321/GeoLite2-Country.mmdb /usr/share/GeoIP/GeoLite2-Country.mmdb

# Clean up
RUN rm -rf /tmp/GeoLite2-Country_*

# Set shell as the entry point
CMD ["/bin/bash"]
