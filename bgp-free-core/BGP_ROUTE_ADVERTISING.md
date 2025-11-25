# BGP Route Advertising - Configuration Guide

## Issue: "No BGP prefixes displayed"

When running `show ip bgp`, you may see:
```
No BGP prefixes displayed, 0 exist
```

This is **EXPECTED** and **NOT an error**. Here's why:

## Why Routes Are Not Displayed

BGP sessions are established between neighbors, but **no routes are being advertised** because:

1. **No network prefixes are configured** - BGP doesn't automatically advertise loopback addresses
2. **No routes are being redistributed** - Static routes or connected routes aren't being shared
3. **No external routes are being injected** - No external BGP peers or route sources

## How to Fix: Advertise Loopback Routes

To advertise loopback addresses via BGP, add `network` commands to the BGP configuration.

### Option 1: Add Network Commands (Recommended)

Update the BGP configuration to advertise loopback networks:

```bash
# For Spine 0
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "configure terminal" \
    -c "router bgp 65000" \
    -c "address-family ipv4 unicast" \
    -c "network 1.1.1.1/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"

# For Spine 1
docker exec clab-folded-clos-URH-TH5-1 vtysh -c "configure terminal" \
    -c "router bgp 65000" \
    -c "address-family ipv4 unicast" \
    -c "network 2.2.2.2/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"

# For Leaf 0
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "configure terminal" \
    -c "router bgp 65100" \
    -c "address-family ipv4 unicast" \
    -c "network 10.10.10.10/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"

# For Leaf 1
docker exec clab-folded-clos-LRH-Q3D-1 vtysh -c "configure terminal" \
    -c "router bgp 65101" \
    -c "address-family ipv4 unicast" \
    -c "network 11.11.11.11/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"

# For Leaf 2
docker exec clab-folded-clos-LRH-Q3D-2 vtysh -c "configure terminal" \
    -c "router bgp 65102" \
    -c "address-family ipv4 unicast" \
    -c "network 12.12.12.12/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"

# For Leaf 3
docker exec clab-folded-clos-LRH-Q3D-3 vtysh -c "configure terminal" \
    -c "router bgp 65103" \
    -c "address-family ipv4 unicast" \
    -c "network 13.13.13.13/32" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"
```

### Option 2: Redistribute Connected Routes

Alternatively, redistribute connected routes (includes loopbacks):

```bash
docker exec clab-folded-clos-URH-TH5-0 vtysh -c "configure terminal" \
    -c "router bgp 65000" \
    -c "address-family ipv4 unicast" \
    -c "redistribute connected" \
    -c "exit-address-family" \
    -c "exit" \
    -c "write memory"
```

## Verify Routes Are Advertised

After adding network commands:

```bash
# Check BGP routes on Leaf 0
docker exec clab-folded-clos-LRH-Q3D-0 vtysh -c "show ip bgp"

# Expected output:
# BGP table version is 5, local router ID is 10.10.10.10
#    Network          Next Hop            Metric LocPrf Weight Path
# *> 1.1.1.1/32       10.0.0.0                 0      32768  65000
# *> 2.2.2.2/32       10.0.0.2                 0      32768  65000
# *> 10.10.10.10/32   0.0.0.0                  0      32768  i
# *> 11.11.11.11/32   10.0.0.0                 0      32768  65101
# *> 12.12.12.12/32   10.0.0.0                 0      32768  65102
# *> 13.13.13.13/32   10.0.0.0                 0      32768  65103
```

## Verify Loopback Connectivity

Once routes are advertised, test end-to-end connectivity:

```bash
# Ping Leaf 1 loopback from Leaf 0
docker exec clab-folded-clos-LRH-Q3D-0 ping -c 3 11.11.11.11

# Expected: 3 packets transmitted, 3 received, 0% packet loss
```

## Summary

- **No BGP prefixes = Normal** if no networks are configured
- **Add network commands** to advertise loopback addresses
- **Verify with `show ip bgp`** after configuration
- **Test with ping** to confirm end-to-end connectivity

