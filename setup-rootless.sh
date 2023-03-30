#!/bin/bash

set -x # Print each command before execution
set -e # fail and abort script if one command fails
set -o pipefail


# Check if CPU, CPUSET, and I/O delegation work properly
# Expected output: cpuset cpu io memory pids
cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.controllers


# Start K3S rootless --------------------------------------------------

wget https://raw.githubusercontent.com/k3s-io/k3s/${INSTALL_K3S_VERSION}/k3s-rootless.service

mkdir -p "$HOME/.config/systemd/user"

mv k3s-rootless.service ~/.config/systemd/user/k3s-rootless.service

systemctl --user daemon-reload

systemctl --user enable --now k3s-rootless

# wait 50 sec to let service become active
sleep 50

# Check if service is active and running
systemctl --user status k3s-rootless --no-pager

KUBECONFIG=~/.kube/k3s.yaml kubectl get pods -A