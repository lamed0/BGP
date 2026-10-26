FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        vim \
        frr \
        iproute2 \
        iputils-ping \
        tcpdump \
        procps && \
    rm -rf /var/lib/apt/lists/*

# Enable the required FRRouting daemons
COPY daemons /etc/frr/daemons

# Load the initial BGP, OSPF and IS-IS configuration
COPY frr.conf /etc/frr/frr.conf

# Set FRRouting configuration permissions
RUN chown frr:frr /etc/frr/frr.conf && \
    chmod 640 /etc/frr/frr.conf

RUN chown root:root /etc/frr/daemons && \
    chmod 644 /etc/frr/daemons

# Start FRRouting and provide an interactive shell for GNS3
CMD ["/bin/sh", "-c", "/usr/lib/frr/frrinit.sh start && exec /bin/bash"]
