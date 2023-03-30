# Rootless K3S
Set up a rootless Kubernetes cluster using [K3S](https://k3s.io/).

This setup uses Containerd as container runtime.

## Setup

For some setup steps, root privileges are still needed. 
However, in the end, Kubernetes will run only with user privileges.

Execute following as non-root user:

```shell
# Configure cgroup v2, cgroup delegation, etc
sudo /bin/bash ./setup-preparation.sh

# reboot needed to make configuration become effective 
sudo reboot

export INSTALL_K3S_VERSION=v1.25.7+k3s1

# Get K3S binaries
# disabling auto-starting and service enablement with the install script
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${INSTALL_K3S_VERSION} INSTALL_K3S_SKIP_START=true INSTALL_K3S_SKIP_ENABLE=true sh -

# Setup and start rootless
/bin/bash ./setup-rootless.sh
```

> Successfully tested on Ubuntu 22.04

## Known Issues

- Do not use `su <user>` or `sudo -u <user>` to execute setup commands as non-root user - instead use `ssh <user>@localhost`

## Troubleshooting
Run to check if cluster is up and running:
```shell
KUBECONFIG=~/.kube/k3s.yaml kubectl get pods -A
```

Run to check the daemon status:
```shell
systemctl --user status k3s-rootless
```

Run to see the daemon log:
```shell
journalctl --user -xu k3s-rootless
```

## Sources
- https://docs.k3s.io/advanced#running-rootless-servers-experimental
- https://docs.k3s.io/advanced#starting-the-service-with-the-installation-script