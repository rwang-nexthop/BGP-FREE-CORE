# BGP-Free Core Topology

## Overview

A folded clos network topology with 6 SONiC nodes:
- **4 Leaf nodes** (Level 0): LRH-Q3D-0, LRH-Q3D-1, LRH-Q3D-2, LRH-Q3D-3
- **2 Spine nodes** (Level 1): URH-TH5-0, URH-TH5-1

Each leaf is connected to both spines (full mesh), creating a folded clos architecture.

## Topology Diagram

```
        URH-TH5-0          URH-TH5-1
        (Spine 0)          (Spine 1)
           |  |  |  |         |  |  |  |
           |  |  |  |         |  |  |  |
        LRH-Q3D-0  LRH-Q3D-1  LRH-Q3D-2  LRH-Q3D-3
        (Leaf 0)   (Leaf 1)   (Leaf 2)   (Leaf 3)
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
3. Configure IP addresses
4. Enable BGP daemon
5. Configure BGP on all nodes
6. Wait for BGP sessions to establish
7. Verify BGP status
8. Test connectivity

## Verification

### Check BGP Status
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary"
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp summary"
```

### Check Routes
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route"
```

### Test Connectivity
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.1.1
docker exec clab-folded-clos-LRH-Q3D-0 ping 10.0.2.1
```

## Cleanup

```bash
cd ~/Python/Projects/bgp-free-core/topology
containerlab destroy -t folded-clos.clab.yml
```

## Files

- **Topology**: `topology/folded-clos.clab.yml`
- **Configuration Script**: `scripts/configure_folded_clos.sh`
- **Documentation**: `README.md`

