# VXLAN Point-to-Point Setup for Folded CLOS Topology

This directory contains scripts to set up and test a VXLAN point-to-point tunnel between **host1** and **host2** in the folded-clos topology.

## Topology Overview

- **host1:** Connected to LRH-Q3D-0 and LRH-Q3D-1 (redundant links)
- **host2:** Connected to LRH-Q3D-2 and LRH-Q3D-3 (redundant links)
- **VXLAN Tunnel:** Single tunnel between host1 and host2 using loopback IPs as VTEPs

## VXLAN Configuration

- **VXLAN Network Identifier (VNI):** 100
- **UDP Port:** 4789 (standard VXLAN port)
- **VTEP Endpoints:**
  - host1 VTEP IP: 192.168.1.10 (local IP on eth1)
  - host2 VTEP IP: 192.168.2.10 (local IP on eth1)
- **Bridge Network:** 10.0.100.0/24
  - host1 Bridge IP: 10.0.100.1/24 (on eth2)
  - host2 Bridge IP: 10.0.100.2/24 (on eth2)
- **Encapsulation:** UDP packets with VXLAN header, routed through folded CLOS network

## Scripts

### 1. VXLAN_setup.sh
**Purpose:** Configure VXLAN tunnel between host1 and host2

**What it does:**
- Verifies both host containers are running
- Creates VXLAN interface (vxlan100) on both hosts
- Creates Linux bridge (br100) on both hosts
- Attaches VXLAN interface to bridge
- Configures bridge IP addresses (10.0.100.0/24)
- Verifies configuration

**Usage:**
```bash
./VXLAN_setup.sh
```

**Output:**
- VXLAN interfaces created and UP
- Bridges created and configured
- IP addresses assigned to bridges
- Configuration verification output

### 2. VXLAN_proof.sh
**Purpose:** Test and verify VXLAN tunnel connectivity

**What it tests:**
1. **VXLAN Interface Status** - Verifies vxlan100 is UP on both hosts
2. **Bridge Status** - Verifies VXLAN interface is attached to bridge
3. **IP Address Configuration** - Verifies bridge IPs are correctly assigned
4. **VXLAN Tunnel Connectivity** - Ping test across tunnel (host1 ↔ host2)
5. **FDB Learning** - Shows forwarding database entries
6. **VXLAN Configuration Details** - Displays detailed VXLAN interface info

**Usage:**
```bash
./VXLAN_proof.sh
```

**Output:**
- Test results with PASS/FAIL indicators
- Summary of passed and failed tests
- Useful commands for manual verification

## Workflow

### Step 1: Deploy Topology
```bash
cd /Users/rwang/Python/Projects/bgp-free-core
sudo clab deploy -t topology/folded-clos.clab.yml
```

This deploys:
- 4 SONiC leaf nodes (LRH-Q3D-0, LRH-Q3D-1, LRH-Q3D-2, LRH-Q3D-3)
- 2 SONiC spine nodes (URH-TH5-0, URH-TH5-1)
- 2 Linux host nodes (host1, host2) using wbitt/network-multitool:alpine-minimal

### Step 2: Configure BGP (Optional)
```bash
./scripts/configure_folded_clos.sh
```

### Step 3: Setup VXLAN
```bash
./scripts/VXLAN_setup.sh
```

### Step 4: Test VXLAN
```bash
./scripts/VXLAN_proof.sh
```

## VXLAN Architecture

```
host1 (192.168.1.10)                   host2 (192.168.2.10)
    │                                       │
    ├─ eth1: 192.168.1.10/24 ──────────────┼─ eth1: 192.168.2.10/24
    │   (Network connectivity)              │   (Network connectivity)
    │                                       │
    ├─ eth2: 10.0.100.1/24 ◄─────────────┐ ├─ eth2: 10.0.100.2/24
    │   (VXLAN bridge)                   │ │   (VXLAN bridge)
    │                                    │ │
    ├─ vxlan100 ◄──────────────────────┤─┤─► vxlan100
    │   (VNI: 100, UDP 4789)            │ │   (VNI: 100, UDP 4789)
    │   VTEP: 192.168.1.10              │ │   VTEP: 192.168.2.10
    │                                    │ │
    ├─ br100 ◄──────────────────────────┘ ├─ br100
    │   (Layer 2 bridge)                   │   (Layer 2 bridge)
    │                                       │
    ├─ LRH-Q3D-0 (Leaf 0)                 ├─ LRH-Q3D-2 (Leaf 2)
    │   192.168.1.1/24                    │   192.168.2.1/24
    │                                       │
    └─ LRH-Q3D-1 (Leaf 1)                 └─ LRH-Q3D-3 (Leaf 3)
        192.168.1.1/24                        192.168.2.1/24
        (Redundant)                           (Redundant)
```

**Underlay Network:** BGP-routed folded CLOS network (192.168.x.x) provides connectivity between VTEP endpoints
**Overlay Network:** VXLAN tunnel (10.0.100.0/24) encapsulates Layer 2 traffic between hosts
**Key Difference:** eth1 carries underlay traffic, eth2 carries overlay traffic (no conflicts)

## Expected Behavior

### Ping vs Traceroute on VXLAN

**Ping (ICMP Echo):** ✅ Works
- Ping packets are delivered directly through the VXLAN bridge
- Response comes back through the tunnel
- Example: `ping 10.0.100.2` from host1 succeeds

**Traceroute (ICMP TTL Exceeded):** Shows "1" with no response (Normal)
- Traceroute relies on intermediate routers to decrement TTL and send "TTL Exceeded" messages
- The VXLAN bridge is a Layer 2 device, not a Layer 3 router
- Since both hosts are on the same Layer 2 network (10.0.100.0/24), packets reach the destination directly
- No intermediate hops exist from the bridge's perspective
- No "TTL Exceeded" message is generated
- This is **completely normal and expected** for any Layer 2 bridge or switch

**IP Routing (via 192.168.x.x):** Shows multiple hops
- When pinging through the underlay network (e.g., `ping 192.168.2.10`), traceroute shows multiple hops
- This is because IP routing involves Layer 3 routers that decrement TTL

## Manual Verification Commands

### Check VXLAN Interface
```bash
docker exec clab-folded-clos-host1 ip link show vxlan100
docker exec clab-folded-clos-host1 ip -d link show vxlan100
```

### Check Bridge Configuration
```bash
docker exec clab-folded-clos-host1 brctl show br100
docker exec clab-folded-clos-host1 ip addr show br100
```

### Check Forwarding Database
```bash
docker exec clab-folded-clos-host1 bridge fdb show dev vxlan100
```

### Test Connectivity
```bash
docker exec clab-folded-clos-host1 ping 10.0.100.2
docker exec clab-folded-clos-host2 ping 10.0.100.1
```

### Capture VXLAN Packets
```bash
docker exec clab-folded-clos-host1 tcpdump -i eth1 -n 'udp port 4789'
```

### Check Host IP Configuration
```bash
docker exec clab-folded-clos-host1 ip addr show
docker exec clab-folded-clos-host2 ip addr show
```

## Troubleshooting

### VXLAN Interface Not UP
- Check if host containers are running: `docker ps | grep host`
- Verify host IPs are configured: `docker exec clab-folded-clos-host1 ip addr show`
- Check if bridge-utils is available: `docker exec clab-folded-clos-host1 which brctl`

### Ping Fails Across Tunnel
- Verify VXLAN interface is UP: `docker exec clab-folded-clos-host1 ip link show vxlan100`
- Check bridge is UP: `docker exec clab-folded-clos-host1 ip link show br100`
- Verify bridge IP is assigned: `docker exec clab-folded-clos-host1 ip addr show br100`
- Check FDB entries: `docker exec clab-folded-clos-host1 bridge fdb show dev vxlan100`
- Verify underlay connectivity: `docker exec clab-folded-clos-host1 ping 192.168.1.2`

### Bridge Not Created
- Ensure bridge-utils is installed in container
- Check for naming conflicts: `docker exec clab-folded-clos-host1 brctl show`
- Verify host has network connectivity to reach the other host's VTEP IP

### Hosts Cannot Reach Each Other
- Check if SONiC leaf nodes are configured and BGP is established
- Verify host eth interfaces are UP: `docker exec clab-folded-clos-host1 ip link show eth1`
- Check routing on leaf nodes: `docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route"`

## References

- RFC 7348: Virtual eXtensible Local Area Network (VXLAN)
- Linux Bridge: https://wiki.linuxfoundation.org/networking/bridge
- VXLAN & Linux: https://vincent.bernat.ch/en/blog/2017-vxlan-linux

