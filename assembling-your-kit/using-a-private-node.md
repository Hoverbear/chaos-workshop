---
description: Provisioning a kit node from an existing node.
---

# Using a Private Node

Perhaps the cost of DigitalOcean is a problem, you can't put some code/data on the cloud, or you prefer using a local VM. No problem.

Spin up a **full Ubuntu Minimal 18.04 VM** using KVM or whatever your infrastructure supports. Since we will be doing kernel level fault injection, creating and manipulating devices, and otherwise doing low level things, we need to have a full OS tree and kernel.

{% hint style="info" %}
Docker is **not** a valid option here. You **must** use a full VM or real hardware.
{% endhint %}

Provisioning is just shelling in, cloning this repository, and running the script:

```bash
git clone https://github.com/Hoverbear/chaos-workshop
chmod +x provision.sh
./provision.sh
```

