#!/bin/bash
set -e

docker build -f Dockerfile.router -t router-mlamrani2:P2 .

echo "Building Part 2 host image..."
docker build -f Dockerfile.host -t host-mlamrani2:P2 .

echo "Router image built successfully!"
