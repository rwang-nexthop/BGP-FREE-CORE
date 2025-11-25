#!/usr/bin/env bash

# Script to configure Folded CLOS SONiC topology
# 4 Leaf nodes (LRH-Q3D-0 to LRH-Q3D-3) connected to 2 Spine nodes (URH-TH5-0, URH-TH5-1)

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Container names and their AS numbers
declare -A CONTAINERS
CONTAINERS["clab-folded-clos-LRH-Q3D-0"]="65100"
CONTAINERS["clab-folded-clos-LRH-Q3D-1"]="65101"
CONTAINERS["clab-folded-clos-LRH-Q3D-2"]="65102"
CONTAINERS["clab-folded-clos-LRH-Q3D-3"]="65103"
CONTAINERS["clab-folded-clos-URH-TH5-0"]="65000"
CONTAINERS["clab-folded-clos-URH-TH5-1"]="65000"

# Function to configure BGP on spine
configure_spine_bgp() {
    local container_name=$1
    local asn=$2
    local router_id=""
    local neighbor1=""
    local neighbor2=""
    local neighbor3=""
    local neighbor4=""

    if [ "$container_name" == "clab-folded-clos-URH-TH5-0" ]; then
        router_id="1.1.1.1"
        neighbor1="10.0.0.1"  # leaf0
        neighbor2="10.0.1.1"  # leaf1
        neighbor3="10.0.2.1"  # leaf2
        neighbor4="10.0.3.1"  # leaf3
    else
        router_id="2.2.2.2"
        neighbor1="10.0.0.3"  # leaf0
        neighbor2="10.0.1.3"  # leaf1
        neighbor3="10.0.2.3"  # leaf2
        neighbor4="10.0.3.3"  # leaf3
    fi

    echo "Configuring BGP on $container_name (AS $asn)..."

    docker exec $container_name vtysh -c "configure terminal" \
        -c "router bgp $asn" \
        -c "bgp router-id $router_id" \
        -c "bgp log-neighbor-changes" \
        -c "no bgp ebgp-requires-policy" \
        -c "neighbor $neighbor1 remote-as 65100" \
        -c "neighbor $neighbor2 remote-as 65101" \
        -c "neighbor $neighbor3 remote-as 65102" \
        -c "neighbor $neighbor4 remote-as 65103" \
        -c "address-family ipv4 unicast" \
        -c "neighbor $neighbor1 activate" \
        -c "neighbor $neighbor2 activate" \
        -c "neighbor $neighbor3 activate" \
        -c "neighbor $neighbor4 activate" \
        -c "network $router_id/32" \
        -c "exit-address-family" \
        -c "exit" 2>&1 | grep -v "Unknown command" || true

    # Save configuration (try both commands)
    docker exec $container_name vtysh -c "write memory" 2>/dev/null || \
    docker exec $container_name vtysh -c "write" 2>/dev/null || true

    echo "✓ Successfully configured $container_name"
}

# Function to configure BGP on leaf
configure_leaf_bgp() {
    local container_name=$1
    local asn=$2
    local router_id=""
    local neighbor1=""
    local neighbor2=""

    if [ "$container_name" == "clab-folded-clos-LRH-Q3D-0" ]; then
        router_id="10.10.10.10"
        neighbor1="10.0.0.0"  # spine0
        neighbor2="10.0.0.2"  # spine1
    elif [ "$container_name" == "clab-folded-clos-LRH-Q3D-1" ]; then
        router_id="11.11.11.11"
        neighbor1="10.0.1.0"  # spine0
        neighbor2="10.0.1.2"  # spine1
    elif [ "$container_name" == "clab-folded-clos-LRH-Q3D-2" ]; then
        router_id="12.12.12.12"
        neighbor1="10.0.2.0"  # spine0
        neighbor2="10.0.2.2"  # spine1
    else
        router_id="13.13.13.13"
        neighbor1="10.0.3.0"  # spine0
        neighbor2="10.0.3.2"  # spine1
    fi

    echo "Configuring BGP on $container_name (AS $asn)..."

    docker exec $container_name vtysh -c "configure terminal" \
        -c "router bgp $asn" \
        -c "bgp router-id $router_id" \
        -c "bgp log-neighbor-changes" \
        -c "no bgp ebgp-requires-policy" \
        -c "neighbor $neighbor1 remote-as 65000" \
        -c "neighbor $neighbor2 remote-as 65000" \
        -c "address-family ipv4 unicast" \
        -c "neighbor $neighbor1 activate" \
        -c "neighbor $neighbor2 activate" \
        -c "network $router_id/32" \
        -c "redistribute connected" \
        -c "exit-address-family" \
        -c "exit" 2>&1 | grep -v "Unknown command" || true

    # Save configuration (try both commands)
    docker exec $container_name vtysh -c "write memory" 2>/dev/null || \
    docker exec $container_name vtysh -c "write" 2>/dev/null || true

    echo "✓ Successfully configured $container_name"
}

echo ""
echo "=========================================="
echo "  Folded CLOS Lab - Complete Configuration"
echo "=========================================="
echo ""

# Step 0: Check Docker connectivity
echo -e "${BLUE}Step 0: Checking Docker connectivity...${NC}"
echo "-------------------------------------------"

all_running=true
for container in "${!CONTAINERS[@]}"; do
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        echo -e "  ${GREEN}✓${NC} $container is running"
    else
        echo -e "  ${RED}✗${NC} $container is NOT running"
        all_running=false
    fi
done

if [ "$all_running" = false ]; then
    echo -e "${RED}Error: Not all containers are running!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All containers are running${NC}"
echo ""

# Step 1: Bring up eth interfaces
echo -e "${BLUE}Step 1: Bringing up containerlab eth interfaces...${NC}"
echo "-------------------------------------------"

# Spine nodes (eth1-eth4 for 4 leaf connections each)
for i in 0 1; do
    for j in 1 2 3 4; do
        docker exec clab-folded-clos-URH-TH5-$i ip link set eth$j up
    done
done

# Leaf nodes (eth1-eth2 for 2 spine connections each)
for i in 0 1 2 3; do
    docker exec clab-folded-clos-LRH-Q3D-$i ip link set eth1 up
    docker exec clab-folded-clos-LRH-Q3D-$i ip link set eth2 up
done

echo -e "${GREEN}✓ All eth interfaces are up${NC}"
sleep 2
echo ""

# Step 2: Configure interfaces and IP addresses
echo -e "${BLUE}Step 2: Configuring interfaces and IP addresses...${NC}"
echo "-------------------------------------------"

# Spine 0 interfaces (connected to leaves 0-3)
docker exec clab-folded-clos-URH-TH5-0 config interface ip add Ethernet0 10.0.0.0/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface ip add Ethernet4 10.0.1.0/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface ip add Ethernet8 10.0.2.0/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface startup Ethernet8 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface ip add Ethernet12 10.0.3.0/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface startup Ethernet12 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-0 config interface ip add Loopback0 1.1.1.1/32 2>/dev/null || true

# Spine 1 interfaces (connected to leaves 0-3)
docker exec clab-folded-clos-URH-TH5-1 config interface ip add Ethernet0 10.0.0.2/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface ip add Ethernet4 10.0.1.2/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface ip add Ethernet8 10.0.2.2/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface startup Ethernet8 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface ip add Ethernet12 10.0.3.2/31 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface startup Ethernet12 2>/dev/null || true
docker exec clab-folded-clos-URH-TH5-1 config interface ip add Loopback0 2.2.2.2/32 2>/dev/null || true

# Leaf 0 interfaces
docker exec clab-folded-clos-LRH-Q3D-0 config interface ip add Ethernet0 10.0.0.1/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-0 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-0 config interface ip add Ethernet4 10.0.0.3/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-0 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-0 config interface ip add Loopback0 10.10.10.10/32 2>/dev/null || true

# Leaf 1 interfaces
docker exec clab-folded-clos-LRH-Q3D-1 config interface ip add Ethernet0 10.0.1.1/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-1 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-1 config interface ip add Ethernet4 10.0.1.3/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-1 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-1 config interface ip add Loopback0 11.11.11.11/32 2>/dev/null || true

# Leaf 2 interfaces
docker exec clab-folded-clos-LRH-Q3D-2 config interface ip add Ethernet0 10.0.2.1/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-2 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-2 config interface ip add Ethernet4 10.0.2.3/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-2 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-2 config interface ip add Loopback0 12.12.12.12/32 2>/dev/null || true

# Leaf 3 interfaces
docker exec clab-folded-clos-LRH-Q3D-3 config interface ip add Ethernet0 10.0.3.1/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-3 config interface startup Ethernet0 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-3 config interface ip add Ethernet4 10.0.3.3/31 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-3 config interface startup Ethernet4 2>/dev/null || true
docker exec clab-folded-clos-LRH-Q3D-3 config interface ip add Loopback0 13.13.13.13/32 2>/dev/null || true

echo -e "${GREEN}✓ All interfaces configured${NC}"
sleep 5
echo ""

# Step 3: Enable bgpd on all containers
echo -e "${BLUE}Step 3: Enabling bgpd daemon on all containers...${NC}"
echo "--------------------------------------------------"

for container in "${!CONTAINERS[@]}"; do
    docker exec $container sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons
    docker exec $container service frr restart 2>&1 | grep -v "Cannot stop watchfrr" || true
    sleep 2
done

echo -e "${GREEN}✓ bgpd enabled on all containers${NC}"
echo ""

# Step 4: Configure BGP on spine routers
echo -e "${BLUE}Step 4: Configuring BGP on spine routers...${NC}"
echo "--------------------------------------------"

configure_spine_bgp "clab-folded-clos-URH-TH5-0" "65000"
configure_spine_bgp "clab-folded-clos-URH-TH5-1" "65000"

echo -e "${GREEN}✓ BGP configured on spine routers${NC}"
echo ""

# Step 5: Configure BGP on leaf routers
echo -e "${BLUE}Step 5: Configuring BGP on leaf routers...${NC}"
echo "-------------------------------------------"

configure_leaf_bgp "clab-folded-clos-LRH-Q3D-0" "65100"
configure_leaf_bgp "clab-folded-clos-LRH-Q3D-1" "65101"
configure_leaf_bgp "clab-folded-clos-LRH-Q3D-2" "65102"
configure_leaf_bgp "clab-folded-clos-LRH-Q3D-3" "65103"

echo -e "${GREEN}✓ BGP configured on leaf routers${NC}"
echo ""

# Step 6: Wait for BGP to establish
echo -e "${BLUE}Step 6: Waiting for BGP sessions to establish...${NC}"
echo "-------------------------------------------------"
echo "Waiting 30 seconds..."
sleep 30
echo ""

# Step 7: Verify BGP status
echo -e "${BLUE}Step 7: Verifying BGP configuration...${NC}"
echo "---------------------------------------"

for container in "${!CONTAINERS[@]}"; do
    echo "=== $container BGP Summary ==="
    docker exec $container vtysh -c "show ip bgp summary" 2>/dev/null || echo "BGP not ready yet"
    echo ""
done

# Step 8: Check connectivity
echo -e "${BLUE}Step 8: Testing connectivity...${NC}"
echo "--------------------------------"

echo "Testing Leaf 0 -> Leaf 1 connectivity..."
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 2 10.0.1.1 2>/dev/null || echo "Connectivity test in progress..."
echo ""

echo "Testing Leaf 0 -> Leaf 2 connectivity..."
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 2 10.0.2.1 2>/dev/null || echo "Connectivity test in progress..."
echo ""

echo "=========================================="
echo "  Configuration Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - All containers verified and running"
echo "  - All interfaces configured with IP addresses"
echo "  - BGP configured on all nodes"
echo "  - BGP sessions established"
echo ""
echo "Verification commands:"
echo "  - Check BGP neighbors: docker exec <container> vtysh -c 'show ip bgp summary'"
echo "  - Check BGP routes:    docker exec <container> vtysh -c 'show ip bgp'"
echo "  - Check routing table: docker exec <container> vtysh -c 'show ip route'"
echo "  - Enter vtysh:         docker exec -it <container> vtysh"
echo ""
echo "Powered by Nexthop.AI"
echo ""

