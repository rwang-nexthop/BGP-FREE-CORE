#!/bin/bash

# Create VXLAN interface and companion bridge for VNI 100 between Leaf 0 and Leaf 3
# Single tunnel: 0↔3 (using eth3 on both leafs)
# VTEP IPs: Leaf0 (10.0.0.1), Leaf3 (10.0.3.1)

echo "Setting up VXLAN tunnel between Leaf 0 and Leaf 3..."
echo ""

# Leaf 0: VXLAN tunnel to Leaf 3 (eth3)
echo "Configuring Leaf 0 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-0 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-0 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-0 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-0 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-0 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-0 ip link set br100 addr aa:bb:cc:00:00:00
docker exec clab-folded-clos-LRH-Q3D-0 ip addr add 10.0.100.0/24 dev br100
echo "✓ Leaf 0 VXLAN configured"
echo ""

# Leaf 3: VXLAN tunnel to Leaf 0 (eth3)
echo "Configuring Leaf 3 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.3.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-3 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-3 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-3 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-3 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-3 ip link set br100 addr aa:bb:cc:00:00:03
docker exec clab-folded-clos-LRH-Q3D-3 ip addr add 10.0.100.3/24 dev br100
echo "✓ Leaf 3 VXLAN configured"
echo ""

echo "VXLAN tunnel between Leaf 0 and Leaf 3 configured successfully!"
