#!/bin/sh

case "$(hostname)" in
    *-1)
        IP="192.168.1.1/24"
        ;;
    *-2)
        IP="192.168.1.2/24"
        ;;
    *)
        echo "Unknown hostname: $(hostname)"
        exit 1
        ;;
esac

ip addr flush dev eth0
ip addr add "$IP" dev eth0
ip link set eth0 up

echo "Host configured with $IP"
