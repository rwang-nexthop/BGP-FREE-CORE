#!/usr/bin/env bash

# Comprehensive connectivity test script for Folded CLOS topology
# Tests all direct links, BGP sessions, and end-to-end connectivity

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                  Folded CLOS Topology - Connectivity Tests                   ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Test 1: Direct Link Connectivity (Layer 2)
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 1: Direct Link Connectivity (Ping across direct links)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Spine 0 to Leaf 0
echo -e "${YELLOW}Spine 0 (10.0.0.0) → Leaf 0 (10.0.0.1):${NC}"
docker exec clab-folded-clos-URH-TH5-0 ping -c 2 10.0.0.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 0 to Leaf 1
echo -e "${YELLOW}Spine 0 (10.0.1.0) → Leaf 1 (10.0.1.1):${NC}"
docker exec clab-folded-clos-URH-TH5-0 ping -c 2 10.0.1.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 0 to Leaf 2
echo -e "${YELLOW}Spine 0 (10.0.2.0) → Leaf 2 (10.0.2.1):${NC}"
docker exec clab-folded-clos-URH-TH5-0 ping -c 2 10.0.2.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 0 to Leaf 3
echo -e "${YELLOW}Spine 0 (10.0.3.0) → Leaf 3 (10.0.3.1):${NC}"
docker exec clab-folded-clos-URH-TH5-0 ping -c 2 10.0.3.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 1 to Leaf 0
echo -e "${YELLOW}Spine 1 (10.0.0.2) → Leaf 0 (10.0.0.3):${NC}"
docker exec clab-folded-clos-URH-TH5-1 ping -c 2 10.0.0.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 1 to Leaf 1
echo -e "${YELLOW}Spine 1 (10.0.1.2) → Leaf 1 (10.0.1.3):${NC}"
docker exec clab-folded-clos-URH-TH5-1 ping -c 2 10.0.1.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 1 to Leaf 2
echo -e "${YELLOW}Spine 1 (10.0.2.2) → Leaf 2 (10.0.2.3):${NC}"
docker exec clab-folded-clos-URH-TH5-1 ping -c 2 10.0.2.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Spine 1 to Leaf 3
echo -e "${YELLOW}Spine 1 (10.0.3.2) → Leaf 3 (10.0.3.3):${NC}"
docker exec clab-folded-clos-URH-TH5-1 ping -c 2 10.0.3.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Test 2: BGP Session Status
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 2: BGP Session Status${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Spine 0 BGP Summary:${NC}"
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary" 2>/dev/null | head -20
echo ""

echo -e "${YELLOW}Spine 1 BGP Summary:${NC}"
docker exec clab-folded-clos-URH-TH5-1 vtysh -c "show ip bgp summary" 2>/dev/null | head -20
echo ""

echo -e "${YELLOW}Leaf 0 BGP Summary:${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp summary" 2>/dev/null | head -20
echo ""

echo -e "${YELLOW}Leaf 1 BGP Summary:${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 vtysh -c "show ip bgp summary" 2>/dev/null | head -20
echo ""

# Test 3: Leaf-to-Leaf Direct Interface Connectivity
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 3: Leaf-to-Leaf Direct Interface Connectivity (via Spines)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 (10.0.0.1) → Leaf 1 (10.0.1.1) via Spine 0:${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 10.0.1.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 (10.0.0.3) → Leaf 1 (10.0.1.3) via Spine 1:${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 10.0.1.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 1 (10.0.1.1) → Leaf 0 (10.0.0.1) via Spine 0:${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 3 10.0.0.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 1 (10.0.1.3) → Leaf 0 (10.0.0.3) via Spine 1:${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 3 10.0.0.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 2 (10.0.2.1) → Leaf 3 (10.0.3.1) via Spine 0:${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 3 10.0.3.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 2 (10.0.2.3) → Leaf 3 (10.0.3.3) via Spine 1:${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 3 10.0.3.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 3 (10.0.3.1) → Leaf 2 (10.0.2.1) via Spine 0:${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 3 10.0.2.1 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 3 (10.0.3.3) → Leaf 2 (10.0.2.3) via Spine 1:${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 3 10.0.2.3 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Test 4: Loopback Connectivity (via BGP routes)
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 4: Loopback Connectivity (via BGP routes)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 → Leaf 1 Loopback (11.11.11.11):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 11.11.11.11 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 → Leaf 2 Loopback (12.12.12.12):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 12.12.12.12 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 → Leaf 3 Loopback (13.13.13.13):${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 13.13.13.13 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 1 → Leaf 0 Loopback (10.10.10.10):${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 3 10.10.10.10 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 1 → Leaf 2 Loopback (12.12.12.12):${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 3 12.12.12.12 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 1 → Leaf 3 Loopback (13.13.13.13):${NC}"
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 3 13.13.13.13 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 2 → Leaf 0 Loopback (10.10.10.10):${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 3 10.10.10.10 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 2 → Leaf 1 Loopback (11.11.11.11):${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 3 11.11.11.11 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 2 → Leaf 3 Loopback (13.13.13.13):${NC}"
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 3 13.13.13.13 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 3 → Leaf 0 Loopback (10.10.10.10):${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 3 10.10.10.10 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 3 → Leaf 1 Loopback (11.11.11.11):${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 3 11.11.11.11 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

echo -e "${YELLOW}Leaf 3 → Leaf 2 Loopback (12.12.12.12):${NC}"
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 3 12.12.12.12 2>/dev/null && echo -e "${GREEN}✓ PASS${NC}" || echo -e "${RED}✗ FAIL${NC}"
echo ""

# Test 5: Routing Table Verification
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 5: Routing Table Verification${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 Routing Table:${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route" 2>/dev/null | head -20
echo ""

echo -e "${YELLOW}Spine 0 Routing Table:${NC}"
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip route" 2>/dev/null | head -20
echo ""

# Test 6: BGP Routes
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test 6: BGP Routes Learned${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Leaf 0 BGP Routes:${NC}"
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp" 2>/dev/null
echo ""

echo -e "${YELLOW}Spine 0 BGP Routes:${NC}"
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp" 2>/dev/null
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Connectivity Tests Complete!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

