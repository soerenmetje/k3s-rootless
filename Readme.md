# Rootless K3S
Setup rootless Kubernetes cluster using [K3S](https://k3s.io/).

## Setup

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