provider digitalocean {
  token = "${var.digitalocean_token}"
}

variable digitalocean_token {
  type = "string"
}

variable count {
  default = 1
}

variable size {
  default = "s-1vcpu-2gb"
}

variable name {
  default = "lab"
}

output ip {
  value = "${digitalocean_droplet.lab.*.ipv4_address}"
}

resource digitalocean_ssh_key operator {
  name       = "operator"
  public_key = "${file("~/.ssh/id_ed25519.pub")}"
}

resource digitalocean_droplet lab {
    name               = "${var.count == 1 ? var.name : format("%02d.%s", count.index, var.name)}"
    count              = "${var.count}"
    image              = "ubuntu-18-04-x64"
    region             = "tor1"
    size               = "${var.size}"
    ssh_keys           = ["${digitalocean_ssh_key.operator.id}"]
    tags               = []
    ipv6               = true
    private_networking = true
    monitoring         = false // This creates a dpkg lock, so do it in provisioning.

    connection {
        type     = "ssh"
        user     = "root"
        private_key = "${file("~/.ssh/id_ed25519")}"
    }

    provisioner remote-exec {
        inline = "${file("provision.sh")}"
    }
  }
