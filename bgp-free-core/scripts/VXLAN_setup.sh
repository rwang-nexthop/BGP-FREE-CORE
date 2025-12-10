#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100 on all leafs
# All leafs are in the same VXLAN (VNI 100)
# VTEP IPs: Leaf0 (10.0.0.1), Leaf1 (10.0.1.1), Leaf2 (10.0.2.1), Leaf3 (10.0.3.1)
# Tunnels: 0↔1, 1↔3, 3↔2, 2↔0 (forming a ring topology)

echo "Setting up VXLAN tunnels on all leafs..."
echo ""

# Leaf 0: VXLAN tunnel to Leaf 1 (eth3) and Leaf 2 (eth4)
echo "Configuring Leaf 0 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-0 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-0 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-0 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-0 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-0 brctl addif br100 eth4
docker exec clab-folded-clos-LRH-Q3D-0 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-0 ip link set up dev eth4
docker exec clab-folded-clos-LRH-Q3D-0 ip link set br100 addr aa:bb:cc:00:00:00
docker exec clab-folded-clos-LRH-Q3D-0 ip addr add 10.0.100.0/24 dev br100
echo "✓ Leaf 0 VXLAN configured"
echo ""

# Leaf 1: VXLAN tunnel to Leaf 0 (eth3) and Leaf 3 (eth4)
echo "Configuring Leaf 1 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.1.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-1 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-1 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-1 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-1 brctl addif br100 eth4
docker exec clab-folded-clos-LRH-Q3D-1 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-1 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-1 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-1 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-1 ip link set up dev eth4
docker exec clab-folded-clos-LRH-Q3D-1 ip link set br100 addr aa:bb:cc:00:00:01
docker exec clab-folded-clos-LRH-Q3D-1 ip addr add 10.0.100.1/24 dev br100
echo "✓ Leaf 1 VXLAN configured"
echo ""

# Leaf 2: VXLAN tunnel to Leaf 3 (eth3) and Leaf 0 (eth4)
echo "Configuring Leaf 2 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.2.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-2 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-2 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-2 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-2 brctl addif br100 eth4
docker exec clab-folded-clos-LRH-Q3D-2 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-2 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-2 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-2 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-2 ip link set up dev eth4
docker exec clab-folded-clos-LRH-Q3D-2 ip link set br100 addr aa:bb:cc:00:00:02
docker exec clab-folded-clos-LRH-Q3D-2 ip addr add 10.0.100.2/24 dev br100
echo "✓ Leaf 2 VXLAN configured"
echo ""

# Leaf 3: VXLAN tunnel to Leaf 1 (eth4) and Leaf 2 (eth3)
echo "Configuring Leaf 3 VXLAN..."
docker exec clab-folded-clos-LRH-Q3D-3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.3.1 nolearning ttl 5
docker exec clab-folded-clos-LRH-Q3D-3 brctl addbr br100
docker exec clab-folded-clos-LRH-Q3D-3 brctl addif br100 vxlan100
docker exec clab-folded-clos-LRH-Q3D-3 brctl addif br100 eth3
docker exec clab-folded-clos-LRH-Q3D-3 brctl addif br100 eth4
docker exec clab-folded-clos-LRH-Q3D-3 brctl stp br100 off
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev br100
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev vxlan100
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev eth3
docker exec clab-folded-clos-LRH-Q3D-3 ip link set up dev eth4
docker exec clab-folded-clos-LRH-Q3D-3 ip link set br100 addr aa:bb:cc:00:00:03
docker exec clab-folded-clos-LRH-Q3D-3 ip addr add 10.0.100.3/24 dev br100
echo "✓ Leaf 3 VXLAN configured"
echo ""

echo "All VXLAN tunnels configured successfully!"
