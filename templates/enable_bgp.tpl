#!/bin/bash

curl -X POST -H "X-Auth-Token: ${token}" https://api.packet.net/devices/${device}/bgp/sessions?address_family=ipv4
