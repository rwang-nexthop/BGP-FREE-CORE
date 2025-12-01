#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100 on host1
# eth1 is dedicated to network connectivity (192.168.1.10)
# eth2 is dedicated to VXLAN bridge (10.0.100.1)
# VTEP IPs: host1 (192.168.1.10) <-> host2 (192.168.2.10)
docker exec clab-folded-clos-host1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 192.168.1.10 remote 192.168.2.10 nolearning ttl 5
docker exec clab-folded-clos-host1 brctl addbr br100
docker exec clab-folded-clos-host1 brctl addif br100 vxlan100
docker exec clab-folded-clos-host1 brctl addif br100 eth2
docker exec clab-folded-clos-host1 brctl stp br100 off
docker exec clab-folded-clos-host1 ip link set up dev br100
docker exec clab-folded-clos-host1 ip link set up dev vxlan100
docker exec clab-folded-clos-host1 ip link set up dev eth2

docker exec clab-folded-clos-host1 ip link set br100 addr aa:bb:cc:00:00:01
docker exec clab-folded-clos-host1 ip addr add 10.0.100.1/24 dev br100

# Create VXLAN interfaces and companion bridges for VNI 100 on host2
# eth1 is dedicated to network connectivity (192.168.2.10)
# eth2 is dedicated to VXLAN bridge (10.0.100.2)
# VTEP IPs: host2 (192.168.2.10) <-> host1 (192.168.1.10)
docker exec clab-folded-clos-host2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 192.168.2.10 remote 192.168.1.10 nolearning ttl 5
docker exec clab-folded-clos-host2 brctl addbr br100
docker exec clab-folded-clos-host2 brctl addif br100 vxlan100
docker exec clab-folded-clos-host2 brctl addif br100 eth2
docker exec clab-folded-clos-host2 brctl stp br100 off
docker exec clab-folded-clos-host2 ip link set up dev br100
docker exec clab-folded-clos-host2 ip link set up dev vxlan100
docker exec clab-folded-clos-host2 ip link set up dev eth2

docker exec clab-folded-clos-host2 ip link set br100 addr aa:bb:cc:00:00:02
docker exec clab-folded-clos-host2 ip addr add 10.0.100.2/24 dev br100
