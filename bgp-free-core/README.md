# BGP-Free Core Topology

## Overview

A folded CLOS network topology with 6 SONiC nodes and 2 Linux host nodes for testing:
- **4 Leaf nodes** (Level 0): LRH-Q3D-0, LRH-Q3D-1, LRH-Q3D-2, LRH-Q3D-3
- **2 Spine nodes** (Level 1): URH-TH5-0, URH-TH5-1
- **2 Host nodes**: host1 (connected to Leaf 0 & 1), host2 (connected to Leaf 2 & 3)

Each leaf is connected to both spines (full mesh), creating a folded CLOS architecture. Host nodes provide endpoints for testing IP connectivity and VXLAN tunneling.

## Topology Diagram

```
                                     ┌───────────────────◄────────┬───────────────────┬───────►───────────────────┐                                   
                                     │                   │        │                   │       │                   │                                   
                                     │  LRH-Q3D-0        │        │  URH-TH5-0        │       │  LRH-Q3D-2        │                                   
                                     │                   │        │                   │       │                   │                                   
                                     │  Leaf 0           │        │  Spine 0          │       │  Leaf 2           │                                   
                                     │                   │        │                   │       │                   │                                   
       ┌───────────────────┐         │  10.10.10.10      │        │  1.1.1.1          │       │  12.12.12.12      │      ┌───────────────────┐        
       │                   ◄─────────┼                   │        │                   │       │                   │      │                   │        
       │   Host 1          │         └──────────────────◄┴──┐     ├───────────────────┤     ┌─►───────────────────┴──────►   Host 2          │        
       │                   │                                │     │                   │     │                            │                   │        
  ┌────┼   192.168.1.10    │                                │ ┌───┘                   └───┐ │                            │   192.168.2.10    ◄─────┐  
  │    │                   │                                │ │                           │ │                            │                   │     │  
  │    │   10.0.100.1      │         ┌───────────────────◄──┼─┘   ┌───────────────────┐   └─┼─►───────────────────┐      │   10.0.100.2      │     │  
  │    │                   ◄─────────┼                   │  │     │  URH-TH5-1        │     │ │                   │      │                   │     │  
  │    └───────────────────┘         │  LRH-Q3D-1        │  └─────┼                   ┼─────┘ │  LRH-Q3D-3        ┼──────►───────────────────┘     │  
  │                                  │                   │        │  Spine 1          │       │                   │                                │  
  │                                  │  Leaf 1           │        │                   │       │  Leaf 3           │                                │  
  │                                  │                   │        │  2.2.2.2          │       │                   │                                │  
  │                                  │  11.11.11.11      │        │                   │       │  13.13.13.13      │                                │  
  │                                  │                   │        │                   │       │                   │                                │  
  │                                  └───────────────────◄────────┴───────────────────┴───────►───────────────────┘                                │  
  │                                                                                                                                                │  
  │                                                                                                                                                │  
  │                                                                                                                                                │  
  │                                                                                                                                                │  
  │                                                                   VXLAN 100                                                                    │  
  └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘  
```

## IP Addressing

### Spine-Leaf Links
- Spine 0 - Leaf 0: 10.0.0.0/31 (Spine) ↔ 10.0.0.1/31 (Leaf)
- Spine 0 - Leaf 1: 10.0.1.0/31 (Spine) ↔ 10.0.1.1/31 (Leaf)
- Spine 0 - Leaf 2: 10.0.2.0/31 (Spine) ↔ 10.0.2.1/31 (Leaf)
- Spine 0 - Leaf 3: 10.0.3.0/31 (Spine) ↔ 10.0.3.1/31 (Leaf)

- Spine 1 - Leaf 0: 10.0.0.2/31 (Spine) ↔ 10.0.0.3/31 (Leaf)
- Spine 1 - Leaf 1: 10.0.1.2/31 (Spine) ↔ 10.0.1.3/31 (Leaf)
- Spine 1 - Leaf 2: 10.0.2.2/31 (Spine) ↔ 10.0.2.3/31 (Leaf)
- Spine 1 - Leaf 3: 10.0.3.2/31 (Spine) ↔ 10.0.3.3/31 (Leaf)

### Loopback Addresses
- URH-TH5-0: 1.1.1.1/32
- URH-TH5-1: 2.2.2.2/32
- LRH-Q3D-0: 10.10.10.10/32
- LRH-Q3D-1: 11.11.11.11/32
- LRH-Q3D-2: 12.12.12.12/32
- LRH-Q3D-3: 13.13.13.13/32

### Host Addresses
- **host1** (connected to Leaf 0 & 1):
  - eth1: 192.168.1.10/24 (network connectivity)
  - eth2: 10.0.100.1/24 (VXLAN bridge)
  - Default route: via 192.168.1.1 (Leaf 0)

- **host2** (connected to Leaf 2 & 3):
  - eth1: 192.168.2.10/24 (network connectivity)
  - eth2: 10.0.100.2/24 (VXLAN bridge)
  - Default route: via 192.168.2.1 (Leaf 2)

### Leaf-to-Host Links
- Leaf 0 (Ethernet8): 192.168.1.1/24 ↔ host1 eth1
- Leaf 1 (Ethernet8): 192.168.1.1/24 ↔ host1 eth2
- Leaf 2 (Ethernet8): 192.168.2.1/24 ↔ host2 eth1
- Leaf 3 (Ethernet8): 192.168.2.1/24 ↔ host2 eth2

## BGP Configuration

### Spine Routers
- **AS Number**: 65000
- **Neighbors**: All 4 leaf routers

### Leaf Routers
- **LRH-Q3D-0**: AS 65100
- **LRH-Q3D-1**: AS 65101
- **LRH-Q3D-2**: AS 65102
- **LRH-Q3D-3**: AS 65103
- **Neighbors**: Both spine routers

## Deployment

### Step 1: Deploy Topology
```bash
cd ~/Python/Projects/bgp-free-core/topology
containerlab deploy -t folded-clos.clab.yml
```

### Step 2: Configure Network
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./configure_folded_clos.sh
```

The script will:
1. Check Docker connectivity
2. Bring up eth interfaces
3. Configure IP addresses on all nodes
4. Configure host IP addresses and default routes
5. Enable BGP daemon on all containers
6. Configure BGP on spine routers
7. Configure BGP on leaf routers
8. Wait for BGP configuration to be applied (5 seconds)
9. Wait for BGP convergence (30 seconds) - **allows full route distribution**
10. Verify BGP status on all nodes
11. Test connectivity between nodes and hosts

**Note:** The script now runs successfully in a single execution. BGP routes are fully distributed after the 30-second convergence wait.

## Verification

### Automated Testing
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./test_connectivity.sh
```

This comprehensive test script verifies:
- Direct link connectivity (8 spine-leaf links)
- BGP session status on all nodes
- Loopback connectivity via BGP routes
- Routing tables on all nodes
- BGP routes learned
- Host-to-host connectivity

### Manual BGP Verification
```bash
# Check BGP status on spine
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary"

# Check BGP status on leaf
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp summary"

# Check routes
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route"

# Check BGP routes
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp"
```

### Manual Connectivity Tests
```bash
# Test leaf-to-leaf connectivity
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.1.1
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.2.1

# Test host-to-host connectivity
docker exec clab-folded-clos-host1 ping 192.168.2.10
docker exec clab-folded-clos-host2 ping 192.168.1.10
```

### VXLAN Testing
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./VXLAN_setup.sh    # Setup VXLAN tunnel
./VXLAN_proof.sh    # Verify VXLAN connectivity
```

## Cleanup

```bash
cd ~/Python/Projects/bgp-free-core/topology
containerlab destroy -t folded-clos.clab.yml
```

## Files

### Topology
- `topology/folded-clos.clab.yml` - Containerlab topology definition with 6 SONiC nodes and 2 host nodes

### Configuration & Testing Scripts
- `scripts/configure_folded_clos.sh` - Complete BGP and IP configuration (runs in single execution)
- `scripts/test_connectivity.sh` - Comprehensive connectivity testing
- `scripts/VXLAN_setup.sh` - VXLAN tunnel configuration between hosts
- `scripts/VXLAN_proof.sh` - VXLAN tunnel verification with 20 comprehensive tests

### Documentation
- `README.md` - This file (main documentation)
- `TEST_COMMANDS.md` - Manual test commands and troubleshooting
- `scripts/VXLAN_README.md` - VXLAN-specific documentation

## Key Features

### BGP Configuration
- ✅ Automatic BGP setup on all nodes
- ✅ Proper timing for route convergence (30-second wait)
- ✅ BGP neighbor descriptions for easy identification
- ✅ Single-run execution (no need to run twice)

### Host Connectivity
- ✅ Host-to-host IP connectivity through folded CLOS network
- ✅ Redundant connections (each host connected to 2 leaves)
- ✅ Default route configuration for proper routing

### VXLAN Overlay
- ✅ Point-to-point VXLAN tunnel between hosts
- ✅ Separate interfaces for network and VXLAN traffic
- ✅ Comprehensive verification tests
- ✅ MAC learning and FDB verification

## Troubleshooting

### BGP Routes Not Distributed
- Ensure `configure_folded_clos.sh` completes fully (takes ~2 minutes)
- Check BGP status: `docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary"`
- Verify FRR daemon is running: `docker exec clab-folded-clos-URH-TH5-0 service frr status`

### Host Connectivity Issues
- Verify host IPs are configured: `docker exec clab-folded-clos-host1 ip addr show`
- Check default routes: `docker exec clab-folded-clos-host1 ip route show`
- Test leaf connectivity: `docker exec clab-folded-clos-host1 ping 192.168.1.1`

### VXLAN Tunnel Not Working
- Verify underlay connectivity: `docker exec clab-folded-clos-host1 ping 192.168.2.10`
- Check VXLAN interface: `docker exec clab-folded-clos-host1 ip link show vxlan100`
- Verify bridge configuration: `docker exec clab-folded-clos-host1 brctl show br100`

See `TEST_COMMANDS.md` for more detailed troubleshooting steps.

