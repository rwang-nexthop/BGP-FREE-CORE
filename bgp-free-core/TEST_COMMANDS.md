# Folded CLOS Topology - Test Commands

## Quick Test (Automated)

### BGP and IP Connectivity Tests
Run the comprehensive test script:
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./test_connectivity.sh
```

This tests:
- Direct link connectivity (8 spine-leaf links)
- BGP session status on all nodes
- Loopback connectivity via BGP routes
- Routing tables on all nodes
- BGP routes learned
- Host-to-host IP connectivity

### VXLAN Tunnel Tests
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./VXLAN_setup.sh    # Setup VXLAN tunnel
./VXLAN_proof.sh    # Run 20 comprehensive VXLAN tests
```

VXLAN tests verify:
- Interface configuration (eth1, eth2, br100, vxlan100)
- VXLAN interface status
- Bridge status and configuration
- Host-to-host VXLAN connectivity (ping)
- Traceroute through VXLAN tunnel
- IP routing to SONiC nodes
- MAC learning (FDB)
- VXLAN configuration details
- Routing tables

---

## Manual Test Commands

### 1. Direct Link Connectivity Tests

**Spine 0 to Leaf 0:**
```bash
docker exec clab-folded-clos-URH-TH5-0 ping -c 4 10.0.0.1
```

**Spine 0 to Leaf 1:**
```bash
docker exec clab-folded-clos-URH-TH5-0 ping -c 4 10.0.1.1
```

**Spine 0 to Leaf 2:**
```bash
docker exec clab-folded-clos-URH-TH5-0 ping -c 4 10.0.2.1
```

**Spine 0 to Leaf 3:**
```bash
docker exec clab-folded-clos-URH-TH5-0 ping -c 4 10.0.3.1
```

**Spine 1 to Leaf 0:**
```bash
docker exec clab-folded-clos-URH-TH5-1 ping -c 4 10.0.0.3
```

**Spine 1 to Leaf 1:**
```bash
docker exec clab-folded-clos-URH-TH5-1 ping -c 4 10.0.1.3
```

**Spine 1 to Leaf 2:**
```bash
docker exec clab-folded-clos-URH-TH5-1 ping -c 4 10.0.2.3
```

**Spine 1 to Leaf 3:**
```bash
docker exec clab-folded-clos-URH-TH5-1 ping -c 4 10.0.3.3
```

---

### 2. BGP Session Status

**Spine 0 BGP Summary:**
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp summary"
```

**Spine 1 BGP Summary:**
```bash
docker exec clab-folded-clos-URH-TH5-1 vtysh -c "show ip bgp summary"
```

**Leaf 0 BGP Summary:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp summary"
```

**Leaf 1 BGP Summary:**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 vtysh -c "show ip bgp summary"
```

**Leaf 2 BGP Summary:**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 vtysh -c "show ip bgp summary"
```

**Leaf 3 BGP Summary:**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 vtysh -c "show ip bgp summary"
```

---

### 3. Leaf-to-Leaf Direct Interface Connectivity

**Leaf 0 → Leaf 1 (via Spine 0):**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 4 10.0.1.1
```

**Leaf 0 → Leaf 1 (via Spine 1):**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 4 10.0.1.3
```

**Leaf 1 → Leaf 0 (via Spine 0):**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 4 10.0.0.1
```

**Leaf 1 → Leaf 0 (via Spine 1):**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 4 10.0.0.3
```

**Leaf 2 → Leaf 3 (via Spine 0):**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 4 10.0.3.1
```

**Leaf 2 → Leaf 3 (via Spine 1):**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 4 10.0.3.3
```

**Leaf 3 → Leaf 2 (via Spine 0):**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 4 10.0.2.1
```

**Leaf 3 → Leaf 2 (via Spine 1):**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 4 10.0.2.3
```

---

### 4. Loopback Connectivity (via BGP)

**Leaf 0 to Leaf 1 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 4 11.11.11.11
```

**Leaf 0 to Leaf 2 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 4 12.12.12.12
```

**Leaf 0 to Leaf 3 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 4 13.13.13.13
```

**Leaf 1 to Leaf 0 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 4 10.10.10.10
```

**Leaf 1 to Leaf 2 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 4 12.12.12.12
```

**Leaf 1 to Leaf 3 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 ping -c 4 13.13.13.13
```

**Leaf 2 to Leaf 0 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 4 10.10.10.10
```

**Leaf 2 to Leaf 1 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 4 11.11.11.11
```

**Leaf 2 to Leaf 3 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-2 ping -c 4 13.13.13.13
```

**Leaf 3 to Leaf 0 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 4 10.10.10.10
```

**Leaf 3 to Leaf 1 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 4 11.11.11.11
```

**Leaf 3 to Leaf 2 Loopback:**
```bash
docker exec clab-folded-clos-LRH-Q3D-3 ping -c 4 12.12.12.12
```

---

### 5. Routing Tables

**Leaf 0 Routing Table:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route"
```

**Leaf 1 Routing Table:**
```bash
docker exec clab-folded-clos-LRH-Q3D-1 vtysh -c "show ip route"
```

**Spine 0 Routing Table:**
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip route"
```

**Spine 1 Routing Table:**
```bash
docker exec clab-folded-clos-URH-TH5-1 vtysh -c "show ip route"
```

---

### 6. BGP Routes

**Leaf 0 BGP Routes:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp"
```

**Spine 0 BGP Routes:**
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp"
```

---

### 7. BGP Neighbors Detail

**Spine 0 BGP Neighbors:**
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show ip bgp neighbors"
```

**Leaf 0 BGP Neighbors:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp neighbors"
```

---

### 8. Interface Status

**Spine 0 Interfaces:**
```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "show interface"
```

**Leaf 0 Interfaces:**
```bash
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show interface"
```

---

### 9. Interactive vtysh Shell

**Enter Spine 0 vtysh:**
```bash
docker exec -it clab-folded-clos-URH-TH5-0 vtysh
```

**Enter Leaf 0 vtysh:**
```bash
docker exec -it clab-folded-clos-LRH-Q3D-0 vtysh
```

Inside vtysh, useful commands:
```
show ip bgp summary
show ip bgp
show ip route
show interface
show ip bgp neighbors
ping <ip>
traceroute <ip>
```

---

### 10. Host Connectivity Tests

**Host1 to Host2 (via IP routing):**
```bash
docker exec clab-folded-clos-host1 ping -c 4 192.168.2.10
```

**Host2 to Host1 (via IP routing):**
```bash
docker exec clab-folded-clos-host2 ping -c 4 192.168.1.10
```

**Host1 to Leaf 0 gateway:**
```bash
docker exec clab-folded-clos-host1 ping -c 4 192.168.1.1
```

**Host2 to Leaf 2 gateway:**
```bash
docker exec clab-folded-clos-host2 ping -c 4 192.168.2.1
```

**Host1 to Host2 (via VXLAN tunnel):**
```bash
docker exec clab-folded-clos-host1 ping -c 4 10.0.100.2
```

**Host2 to Host1 (via VXLAN tunnel):**
```bash
docker exec clab-folded-clos-host2 ping -c 4 10.0.100.1
```

---

### 11. Host Configuration Verification

**Check Host1 IP configuration:**
```bash
docker exec clab-folded-clos-host1 ip addr show
```

**Check Host2 IP configuration:**
```bash
docker exec clab-folded-clos-host2 ip addr show
```

**Check Host1 routing table:**
```bash
docker exec clab-folded-clos-host1 ip route show
```

**Check Host2 routing table:**
```bash
docker exec clab-folded-clos-host2 ip route show
```

**Check Host1 VXLAN bridge:**
```bash
docker exec clab-folded-clos-host1 brctl show br100
```

**Check Host2 VXLAN bridge:**
```bash
docker exec clab-folded-clos-host2 brctl show br100
```

---

### 12. Container Shell Access

**Access Spine 0 shell:**
```bash
docker exec -it clab-folded-clos-URH-TH5-0 bash
```

**Access Leaf 0 shell:**
```bash
docker exec -it clab-folded-clos-LRH-Q3D-0 bash
```

**Access Host1 shell:**
```bash
docker exec -it clab-folded-clos-host1 bash
```

**Access Host2 shell:**
```bash
docker exec -it clab-folded-clos-host2 bash
```

---

## Expected Results

### Direct Links
- All 8 direct spine-leaf links should respond to ping
- Response time typically < 1ms

### BGP Sessions
- Each leaf should have 2 established neighbors (both spines)
- Each spine should have 4 established neighbors (all leaves)
- Total: 12 BGP sessions
- All neighbors should show "Established" state with message counts > 0

### Loopback Connectivity
- All loopback addresses should be reachable via BGP routes
- Packets should traverse through spines
- Response time typically 1-2ms

### Routing
- Each node should have routes to all other loopback addresses
- Routes should be learned via BGP
- Each leaf should have routes to all other leaf loopbacks

### Host Connectivity
- **IP Routing:** host1 (192.168.1.10) ↔ host2 (192.168.2.10) should be reachable
  - Packets route through folded CLOS network
  - Response time typically 1-2ms

- **VXLAN Tunnel:** host1 (10.0.100.1) ↔ host2 (10.0.100.2) should be reachable
  - Packets encapsulated in UDP/VXLAN and routed through underlay
  - Response time typically 1-2ms
  - Traceroute shows "1" with no response (normal for Layer 2 bridge)

### BGP Route Distribution
- All leaf loopback routes should be advertised to spines
- All spine loopback routes should be advertised to leaves
- Host networks (192.168.1.0/24, 192.168.2.0/24) should be advertised by leaves

---

## Troubleshooting

### General Issues

1. **Check container status:**
   ```bash
   docker ps | grep folded-clos
   ```

2. **Check interface status:**
   ```bash
   docker exec clab-folded-clos-URH-TH5-0 ip link show
   ```

3. **Check IP configuration:**
   ```bash
   docker exec clab-folded-clos-URH-TH5-0 ip addr show
   ```

4. **Check BGP daemon status:**
   ```bash
   docker exec clab-folded-clos-URH-TH5-0 service frr status
   ```

5. **View FRR logs:**
   ```bash
   docker exec clab-folded-clos-URH-TH5-0 tail -f /var/log/frr/bgpd.log
   ```

### BGP Issues

**BGP neighbors show "Active" state (not "Established"):**
- Wait longer for BGP to establish (up to 30 seconds)
- Check if interfaces are UP: `docker exec clab-folded-clos-URH-TH5-0 ip link show`
- Verify IP addresses are configured: `docker exec clab-folded-clos-URH-TH5-0 ip addr show`
- Check FRR daemon: `docker exec clab-folded-clos-URH-TH5-0 service frr status`

**BGP routes not being advertised:**
- Ensure `configure_folded_clos.sh` completed successfully
- Check BGP configuration: `docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show running-config"`
- Verify network statements in BGP config: `docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp"`

### Host Connectivity Issues

**Host-to-host ping fails:**
- Verify host IPs are configured: `docker exec clab-folded-clos-host1 ip addr show`
- Check default routes: `docker exec clab-folded-clos-host1 ip route show`
- Test connectivity to leaf gateway: `docker exec clab-folded-clos-host1 ping 192.168.1.1`
- Verify leaf routing: `docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip route"`

### VXLAN Issues

**VXLAN tunnel not working:**
- Verify underlay connectivity: `docker exec clab-folded-clos-host1 ping 192.168.2.10`
- Check VXLAN interface: `docker exec clab-folded-clos-host1 ip link show vxlan100`
- Verify bridge configuration: `docker exec clab-folded-clos-host1 brctl show br100`
- Check bridge IPs: `docker exec clab-folded-clos-host1 ip addr show br100`
- Verify FDB entries: `docker exec clab-folded-clos-host1 bridge fdb show dev vxlan100`

**Traceroute shows "1" with no response:**
- This is **normal** for VXLAN bridges (Layer 2 devices)
- Ping should still work: `docker exec clab-folded-clos-host1 ping 10.0.100.2`
- See VXLAN_README.md for explanation

