#!/bin/sh

systemctl restart docker etcd kube-apiserver  kubelet.service  kube-proxy.service  kube-scheduler.service kube-controller-manager

