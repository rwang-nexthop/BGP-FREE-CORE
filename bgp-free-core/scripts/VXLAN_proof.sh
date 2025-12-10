#!/bin/bash

# VXLAN Verification Script for folded-clos topology
# Tests VXLAN tunnel connectivity between all leafs (0↔1, 1↔3, 3↔2, 2↔0)
# All leafs are in the same VXLAN (VNI 100)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║              VXLAN Verification (All Leafs - Ring Topology)                  ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "VXLAN Configuration:"
echo "  - VNI: 100"
echo "  - UDP Port: 4789"
echo "  - Topology: Ring (0↔1, 1↔3, 3↔2, 2↔0)"
echo "  - Bridge: br100 with vxlan100 interface"
echo "  - VXLAN IPs: Leaf0 (10.0.100.0), Leaf1 (10.0.100.1), Leaf2 (10.0.100.2), Leaf3 (10.0.100.3)"
echo ""

# Test 1: VXLAN interface status on all leafs
echo -e "${BLUE}Test 1: VXLAN interface status on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf ip link show vxlan100
    echo ""
done

# Test 2: Bridge status on all leafs
echo -e "${BLUE}Test 2: Bridge status on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf ip link show br100
    echo ""
done

# Test 3: Bridge IP configuration on all leafs
echo -e "${BLUE}Test 3: Bridge IP configuration on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf ip addr show br100
    echo ""
done

# Test 4: Ping connectivity between adjacent leafs (ring topology)
echo -e "${BLUE}Test 4: Ping connectivity between adjacent leafs (ring topology)${NC}"
echo "-------------------------------------------"

# Leaf 0 to Leaf 1
echo -e "${YELLOW}Leaf 0 (10.0.100.0) → Leaf 1 (10.0.100.1):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 2 10.0.100.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Leaf 1 to Leaf 3
echo -e "${YELLOW}Leaf 1 (10.0.100.1) → Leaf 3 (10.0.100.3):${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 2 10.0.100.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Leaf 3 to Leaf 2
echo -e "${YELLOW}Leaf 3 (10.0.100.3) → Leaf 2 (10.0.100.2):${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 2 10.0.100.2 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Leaf 2 to Leaf 0
echo -e "${YELLOW}Leaf 2 (10.0.100.2) → Leaf 0 (10.0.100.0):${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 2 10.0.100.0 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Test 5: Ping connectivity between non-adjacent leafs (via ring)
echo -e "${BLUE}Test 5: Ping connectivity between non-adjacent leafs (via ring)${NC}"
echo "-------------------------------------------"

# Leaf 0 to Leaf 3
echo -e "${YELLOW}Leaf 0 (10.0.100.0) → Leaf 3 (10.0.100.3):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 2 10.0.100.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Leaf 1 to Leaf 2
echo -e "${YELLOW}Leaf 1 (10.0.100.1) → Leaf 2 (10.0.100.2):${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 2 10.0.100.2 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Test 6: Check FDB (Forwarding Database) on all leafs
echo -e "${BLUE}Test 6: FDB (MAC Learning) on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf brctl showmacs br100
    echo ""
done

# Test 7: Show VXLAN configuration details on all leafs
echo -e "${BLUE}Test 7: VXLAN configuration details on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf ip -d link show vxlan100
    echo ""
done

# Test 8: Show routing table on all leafs
echo -e "${BLUE}Test 8: Routing table on all leafs${NC}"
echo "-------------------------------------------"
for leaf in 0 1 2 3; do
    echo -e "${YELLOW}Leaf $leaf:${NC}"
    docker exec clab-folded-clos-LRH-Q3D-$leaf ip route | grep -E "10.0.100|br100"
    echo ""
done

# Test 9: Traceroute between leafs
echo -e "${BLUE}Test 9: Traceroute between leafs${NC}"
echo "-------------------------------------------"

echo -e "${YELLOW}Leaf 0 → Leaf 1 (10.0.100.1):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 traceroute -m 5 10.0.100.1 2>/dev/null || echo "traceroute not available"
echo ""

echo -e "${YELLOW}Leaf 0 → Leaf 3 (10.0.100.3):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 traceroute -m 5 10.0.100.3 2>/dev/null || echo "traceroute not available"
echo ""

echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    VXLAN Verification Complete                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Summary:"
echo "  - All leafs in same VXLAN (VNI 100)"
echo "  - Ring topology: 0↔1, 1↔3, 3↔2, 2↔0"
echo "  - VXLAN encapsulation: UDP port 4789"
echo "  - Bridge MAC addresses: aa:bb:cc:00:00:00 (Leaf0), aa:bb:cc:00:00:01 (Leaf1),"
echo "                          aa:bb:cc:00:00:02 (Leaf2), aa:bb:cc:00:00:03 (Leaf3)"
echo ""
