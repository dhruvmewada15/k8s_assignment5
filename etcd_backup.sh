#!/bin/bash

sudo ETCDCTL_API=3 \
etcdctl --endpoints=https://192.168.56.101:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
 snapshot save $PWD/etcd-snapshot

# Run above shell script for taking the etcd-backup at the PWD location
