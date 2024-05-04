# Use the base Ubuntu image
FROM ubuntu:latest

# Update the package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    suricata \
    sed

# Create Suricata configuration file
RUN touch /etc/default/suricata && \
    echo "LISTENMODE=nfqueue" >> /etc/default/suricata && \
    echo "IFACE=ens3" >> /etc/default/suricata

# Create Suricata rules directory and file
RUN mkdir -p /var/lib/suricata/rules/ && \
    touch /var/lib/suricata/rules/suricata.rules && \
    sed -i -e '/ATTACK_RESPONSE/ s/^alert/drop/' /var/lib/suricata/rules/suricata.rules && \
    sed -i -e '/USER_AGENTS/ s/^alert/drop/' /var/lib/suricata/rules/suricata.rules

# Create Suricata configuration directory and YAML file
RUN mkdir -p /etc/suricata/ && \
    touch /etc/suricata/suricata.yaml && \
    echo "mode: nfqueue" >> /etc/suricata/suricata.yaml

# Expose any necessary ports for Suricata
# EXPOSE 12345 (example port)

# Restart Suricata service
CMD service suricata restart
