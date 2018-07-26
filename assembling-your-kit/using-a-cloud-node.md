---
description: Spawning a kit node on DigitalOcean.
---

# Using a Cloud Node

If you haven't already head on over to [DigitalOcean](http://digitalocean.com/) and [Sign Up \(referral\)](https://m.do.co/c/b6156cf29450), then get a [Read/Write API token](https://cloud.digitalocean.com/account/api/tokens/new). Then, create a file in the working directory called `terraform.tfvars`:

{% code-tabs %}
{% code-tabs-item title="terraform.tfvars" %}
```bash
digitalocean_token = "your token here"
```
{% endcode-tabs-item %}
{% endcode-tabs %}

Additionally, ensure you have an SSH key set up.

```bash
ssh-keygen -t ed25519
```

Next, we'll run Terraform. This **will cost you money**. The currently the default machine size costs $20 USD per month, billed hourly.

```bash
terraform apply
```

You'll see one SSH key created, and one node created. It will take awhile to provision \(give it at least 30 minutes\).

When Terraform is done it will output an IP.  That's your machine, so shell in and let's start exploring!

```text
ssh root@$CREATED_HOST_IP
```

When you're all done you can destroy the machine, clearing any ongoing charges.

```text
terraform destroy
```



