#!/bin/bash

# VXLAN Verification Script for folded-clos topology
# Tests VXLAN tunnel connectivity between host1 and host2
# Verifies that host-to-host traffic uses VXLAN while host-to-SONiC traffic uses IP

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║              VXLAN Verification (host1 ↔ host2)                              ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Interface Configuration:"
echo "  - eth1: Dedicated to network connectivity (192.168.1.x / 192.168.2.x)"
echo "  - eth2: Dedicated to VXLAN bridge (10.0.100.x)"
echo "  - br100: VXLAN bridge with vxlan100 interface"
echo ""

# Test 1: Interface configuration on host1
echo -e "${BLUE}Test 1: Interface configuration on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 bash -c "ip link show eth1; ip link show eth2; ip link show br100; ip link show vxlan100"
echo ""

# Test 2: Interface configuration on host2
echo -e "${BLUE}Test 2: Interface configuration on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 bash -c "ip link show eth1; ip link show eth2; ip link show br100; ip link show vxlan100"
echo ""

# Test 3: VXLAN interface status on host1
echo -e "${BLUE}Test 3: VXLAN interface status on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ip link show vxlan100
echo ""

# Test 4: VXLAN interface status on host2
echo -e "${BLUE}Test 4: VXLAN interface status on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ip link show vxlan100
echo ""

# Test 5: Bridge status on host1
echo -e "${BLUE}Test 5: Bridge status on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ip link show br100
echo ""

# Test 6: Bridge status on host2
echo -e "${BLUE}Test 6: Bridge status on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ip link show br100
echo ""

# Test 7: Bridge IP configuration on host1
echo -e "${BLUE}Test 7: Bridge IP configuration on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ip addr show br100
echo ""

# Test 8: Bridge IP configuration on host2
echo -e "${BLUE}Test 8: Bridge IP configuration on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ip addr show br100
echo ""

# Test 9: Ping from host1 to host2 via VXLAN bridge (10.0.100.x)
echo -e "${BLUE}Test 9: Connectivity via VXLAN bridge (host1 -> host2 via 10.0.100.2)${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ping -c 3 10.0.100.2
echo ""

# Test 10: Ping from host2 to host1 via VXLAN bridge (10.0.100.x)
echo -e "${BLUE}Test 10: Connectivity via VXLAN bridge (host2 -> host1 via 10.0.100.1)${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ping -c 3 10.0.100.1
echo ""

# Test 11: Traceroute from host1 to host2 via VXLAN bridge
echo -e "${BLUE}Test 11: Traceroute from host1 to host2 via VXLAN bridge (10.0.100.2)${NC}"
echo "-------------------------------------------"
echo "Expected: Direct connection via VXLAN (single hop)"
docker exec clab-folded-clos-host1 traceroute -m 5 10.0.100.2 2>/dev/null || echo "traceroute not available"
echo ""

# Test 12: Traceroute from host2 to host1 via VXLAN bridge
echo -e "${BLUE}Test 12: Traceroute from host2 to host1 via VXLAN bridge (10.0.100.1)${NC}"
echo "-------------------------------------------"
echo "Expected: Direct connection via VXLAN (single hop)"
docker exec clab-folded-clos-host2 traceroute -m 5 10.0.100.1 2>/dev/null || echo "traceroute not available"
echo ""

# Test 13: Ping from host1 to SONiC node via IP (192.168.1.1)
echo -e "${BLUE}Test 13: Connectivity from host1 to Leaf 0 gateway via IP (192.168.1.1)${NC}"
echo "-------------------------------------------"
echo "Expected: Routes through IP network (not VXLAN)"
docker exec clab-folded-clos-host1 ping -c 3 192.168.1.1
echo ""

# Test 14: Ping from host2 to SONiC node via IP (192.168.2.1)
echo -e "${BLUE}Test 14: Connectivity from host2 to Leaf 2 gateway via IP (192.168.2.1)${NC}"
echo "-------------------------------------------"
echo "Expected: Routes through IP network (not VXLAN)"
docker exec clab-folded-clos-host2 ping -c 3 192.168.2.1
echo ""

# Test 15: Check FDB (Forwarding Database) on host1
echo -e "${BLUE}Test 15: FDB (MAC Learning) on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 brctl showmacs br100
echo ""

# Test 16: Check FDB (Forwarding Database) on host2
echo -e "${BLUE}Test 16: FDB (MAC Learning) on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 brctl showmacs br100
echo ""

# Test 17: Show VXLAN configuration details on host1
echo -e "${BLUE}Test 17: VXLAN configuration details on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ip -d link show vxlan100
echo ""

# Test 18: Show VXLAN configuration details on host2
echo -e "${BLUE}Test 18: VXLAN configuration details on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ip -d link show vxlan100
echo ""

# Test 19: Show routing table on host1
echo -e "${BLUE}Test 19: Routing table on host1${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host1 ip route
echo ""

# Test 20: Show routing table on host2
echo -e "${BLUE}Test 20: Routing table on host2${NC}"
echo "-------------------------------------------"
docker exec clab-folded-clos-host2 ip route
echo ""

echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    VXLAN Verification Complete                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Summary:"
echo "  - Host-to-Host (10.0.100.x): Should use VXLAN tunnel (single hop)"
echo "  - Host-to-SONiC (192.168.x.x): Should use IP routing (multiple hops)"
echo "  - VXLAN encapsulation: UDP port 4789, VNI 100"
echo "  - Bridge MAC addresses: aa:bb:cc:00:00:01 (host1), aa:bb:cc:00:00:02 (host2)"
echo ""
