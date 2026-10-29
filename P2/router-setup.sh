#!/bin/sh
set -e

# Identify router using hostname
case "$(hostname)" in
    router-mlamrani-1|router-mlamrani2-1)
        LOCAL_IP="10.0.0.1"
        ;;
    router-mlamrani-2|router-mlamrani2-2)
        LOCAL_IP="10.0.0.2"
        ;;
    *)
        echo "Unknown router hostname: $(hostname)"
        exit 1
        ;;
esac
echo "Configuring $(hostname)..."

# Wait for network interfaces
until ip link show eth0 >/dev/null 2>&1 &&
      ip link show eth1 >/dev/null 2>&1; do
    sleep 1
done

# Configure underlay
ip link set eth0 nomaster 2>/dev/null || true
ip link set eth0 up
ip addr replace "$LOCAL_IP/24" dev eth0

# Create bridge
ip link show br0 >/dev/null 2>&1 || ip link add br0 type bridge
ip link set br0 up

# Remove existing VXLAN
if ip link show vxlan10 >/dev/null 2>&1; then
    ip link del vxlan10
fi

# Configure multicast VXLAN
ip link add vxlan10 type vxlan \
    id 10 \
    dev eth0 \
    local "$LOCAL_IP" \
    group 239.1.1.1 \
    dstport 4789

# Attach interfaces to bridge
ip link set eth1 master br0
ip link set vxlan10 master br0

# Enable interfaces
ip link set eth1 up
ip link set vxlan10 up

echo "$(hostname) configured successfully!"
