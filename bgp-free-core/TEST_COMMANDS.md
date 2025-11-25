# Folded CLOS Topology - Test Commands

## Quick Test (Automated)

Run the comprehensive test script:
```bash
cd ~/Python/Projects/bgp-free-core/scripts
./test_connectivity.sh
```

This tests:
- Direct link connectivity (8 links)
- BGP session status
- Loopback connectivity
- Routing tables
- BGP routes learned

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

### 10. Container Shell Access

**Access Spine 0 shell:**
```bash
docker exec -it clab-folded-clos-URH-TH5-0 bash
```

**Access Leaf 0 shell:**
```bash
docker exec -it clab-folded-clos-LRH-Q3D-0 bash
```

---

## Expected Results

### Direct Links
- All 8 direct links should respond to ping
- Response time typically < 1ms

### BGP Sessions
- Each leaf should have 2 established neighbors (both spines)
- Each spine should have 4 established neighbors (all leaves)
- Total: 12 BGP sessions

### Loopback Connectivity
- All loopback addresses should be reachable via BGP routes
- Packets should traverse through spines

### Routing
- Each node should have routes to all other loopback addresses
- Routes should be learned via BGP

---

## Troubleshooting

If tests fail:

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

