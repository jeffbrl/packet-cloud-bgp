#!/bin/bash

export PRIVATEIP=`ip addr show bond0 | grep -Po 'inet \K[\d.]+' | grep 10`
export ANYCASTIP=`ip addr show lo | grep -Po 'inet \K[\d.]+' | grep -v 127`
export NEIGHBOR=`ip route show | grep "src 10" | awk '{ print $1 }' | sed 's/\/.*//'`
cat /tmp/bird.conf | sed s/PRIVATEIP/$PRIVATEIP/ > /tmp/bird1.conf
cat /tmp/bird1.conf | sed s/ANYCASTIP/$ANYCASTIP/ > /tmp/bird2.conf
cat /tmp/bird2.conf | sed s/NEIGHBOR/$NEIGHBOR/ > /tmp/bird3.conf
mv /tmp/bird3.conf /etc/bird/bird.conf

DEVICE_ID=`curl https://metadata.packet.net/metadata | jq .id`
DEVICE_ID=`echo $DEVICE_ID | sed 's/"//g'`

TOKEN=${token}
curl -X POST -H "X-Auth-Token: $TOKEN" https://api.packet.net/devices/$DEVICE_ID/bgp/sessions?address_family=ipv4
service bird restart
