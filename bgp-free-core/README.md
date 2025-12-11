# BGP-Free Core Topology

## Overview

A folded CLOS network topology with 6 SONiC nodes for testing:
- **4 Leaf nodes** (Level 0): LRH-Q3D-0, LRH-Q3D-1, LRH-Q3D-2, LRH-Q3D-3
- **2 Spine nodes** (Level 1): URH-TH5-0, URH-TH5-1

Each leaf is connected to both spines (full mesh), creating a folded CLOS architecture. A VXLAN tunnel is configured between Leaf 0 and Leaf 3 for Layer 2 overlay testing.

## Topology Diagram

```
                                     ┌───────────────────◄────────┬───────────────────┬───────►───────────────────┐                                   
                                     │                   │        │                   │       │                   │                                   
                                     │  LRH-Q3D-0        │        │  URH-TH5-0        │       │  LRH-Q3D-2        │                                   
                                     │                   │        │                   │       │                   │                                   
                                     │  Leaf 0           │        │  Spine 0          │       │  Leaf 2           │                                   
                                     │                   │        │                   │       │                   │                                   
                                ┌─►  │  10.10.10.10      │        │  1.1.1.1          │       │  12.12.12.12      │         
                                │    │                   │        │                   │       │                   │ 
                                │    └──────────────────◄┴──┐     ├───────────────────┤     ┌─►───────────────────┴
                                │                           │     │                   │     │                      
                                │                           │ ┌───┘                   └───┐ │                      
                                │                           │ │                           │ │                      
                                │     ───────────────────◄──┼─┘   ┌───────────────────┐   └─┼─►───────────────────┐
                                │    │                   │  │     │  URH-TH5-1        │     │ │                   │
                                │    │  LRH-Q3D-1        │  └─────┼                   ┼─────┘ │  LRH-Q3D-3        │
                                │    │                   │        │  Spine 1          │       │                   │
                                │    │  Leaf 1           │        │                   │       │  Leaf 3           │
                                │    │                   │        │  2.2.2.2          │       │                   │
                                │    │  11.11.11.11      │        │                   │       │  13.13.13.13      │
                                │    │                   │        │                   │       │                   │
                                │    └───────────────────◄────────┴───────────────────┴───────►───────────────────┘
                                │                                                                                 │ 
                                │                                                                                 │ 
                                │                                                                                 │ 
                                │                                                                                 │ 
                                │                                       VXLAN 100                                 │  
                                └─────────────────────────────────────────────────────────────────────────────────┘
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

### VXLAN Tunnel (Leaf 0 ↔ Leaf 3)
- **VNI**: 100
- **Leaf 0 VTEP IP**: 10.0.0.1 (local)
- **Leaf 3 VTEP IP**: 10.0.3.1 (remote)
- **Bridge Network**: 10.0.100.0/24
  - Leaf 0 Bridge IP: 10.0.100.0/24
  - Leaf 3 Bridge IP: 10.0.100.3/24
- **Physical Interface**: eth3 on both Leaf 0 and Leaf 3
- **UDP Port**: 4789

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
2. Bring up eth interfaces (eth1, eth2 for spine connections; eth3 for VXLAN on Leaf 0 & 3)
3. Configure IP addresses on all nodes
4. Enable BGP daemon on all containers
5. Configure BGP on spine routers
6. Configure BGP on leaf routers
7. Wait for BGP convergence (30 seconds) - **allows full route distribution**
8. Verify BGP status on all nodes
9. Test leaf-to-leaf connectivity

**Note:** The script runs successfully in a single execution. BGP routes are fully distributed after the 30-second convergence wait.

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
- Leaf-to-leaf connectivity

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
# Test leaf-to-leaf connectivity via BGP routes
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.1.1
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.2.1
docker exec clab-folded-clos-LRH-Q3D-0 ping 13.13.13.13

# Test VXLAN tunnel connectivity (bridge IPs)
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.100.3
```

### VXLAN Testing
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./VXLAN_setup.sh    # Setup VXLAN tunnel between Leaf 0 and Leaf 3
./VXLAN_proof.sh    # Verify VXLAN connectivity with 16 comprehensive tests
```

## Cleanup

```bash
cd ~/Python/Projects/bgp-free-core/topology
containerlab destroy -t folded-clos.clab.yml
```

## Files

### Topology
- `topology/folded-clos.clab.yml` - Containerlab topology definition with 6 SONiC nodes and VXLAN tunnel between Leaf 0 and Leaf 3

### Configuration & Testing Scripts
- `scripts/configure_folded_clos.sh` - Complete BGP and IP configuration (runs in single execution)
- `scripts/test_connectivity.sh` - Comprehensive connectivity testing
- `scripts/VXLAN_setup.sh` - VXLAN tunnel configuration between Leaf 0 and Leaf 3
- `scripts/VXLAN_proof.sh` - VXLAN tunnel verification with 16 comprehensive tests

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
- ✅ Dual-spine redundancy with equal-cost multipath routing

### Leaf-to-Leaf Connectivity
- ✅ Full mesh connectivity between all leaf nodes via spines
- ✅ BGP-based routing with loopback reachability
- ✅ Automatic failover between spines

### VXLAN Overlay
- ✅ Point-to-point VXLAN tunnel between Leaf 0 and Leaf 3
- ✅ Separate interfaces for underlay (eth1, eth2) and overlay (eth3) traffic
- ✅ 16 comprehensive verification tests
- ✅ MAC learning and FDB verification
- ✅ Layer 2 bridge connectivity across VXLAN tunnel

## Troubleshooting

### BGP Routes Not Distributed
- Ensure `configure_folded_clos.sh` completes fully (takes ~2 minutes)
- Check BGP status: `docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary"`
- Verify FRR daemon is running: `docker exec clab-folded-clos-URH-TH5-0 service frr status`
- Check BGP neighbors are in Established state: `docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp neighbors"`

### Leaf-to-Leaf Connectivity Issues
- Verify loopback IPs are configured: `docker exec clab-folded-clos-LRH-Q3D-0 ip addr show Loopback0`
- Check routing table: `docker exec clab-folded-clos-LRH-Q3D-0 ip route show`
- Test spine connectivity: `docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.0.0`

### VXLAN Tunnel Not Working
- Verify VXLAN interface is UP: `docker exec clab-folded-clos-LRH-Q3D-0 ip link show vxlan100`
- Check bridge configuration: `docker exec clab-folded-clos-LRH-Q3D-0 ip addr show br100`
- Verify eth3 is UP: `docker exec clab-folded-clos-LRH-Q3D-0 ip link show eth3`
- Test VXLAN connectivity: `docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.100.3`
- Check FDB entries: `docker exec clab-folded-clos-LRH-Q3D-0 bridge fdb show dev vxlan100`

See `TEST_COMMANDS.md` for more detailed troubleshooting steps.

