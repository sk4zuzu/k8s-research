
resource "libvirt_domain" "k8s-master" {
    count = "${var.master-resources["count"]}"
    name = "k8s-master.${count.index}"

    vcpu = "${var.master-resources["vcpu"]}"
    memory = "${var.master-resources["memory"]}"

    cloudinit = "${element(libvirt_cloudinit.k8s-master.*.id, count.index)}"

    network_interface {
        network_id = "${libvirt_network.k8s-network.id}"
        wait_for_lease = 1
    }

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    disk {
        volume_id = "${element(libvirt_volume.k8s-master.*.id, count.index)}"
	}

    connection = {
        type = "ssh"
        user = "${var.base-volume["username"]}"
        private_key = "${var.ssh-provisioning-key}"
    }

    provisioner "file" {
        source = "./scripts/master.sh"
        destination = "/tmp/master.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/master.sh",
            "sudo -iu root /tmp/master.sh ${var.k8s-token} ${libvirt_domain.k8s-master.0.network_interface.0.addresses.0}",
        ]
    }
}

resource "libvirt_domain" "k8s-node" {
    count = "${var.node-resources["count"]}"
    name = "k8s-node.${count.index}"

    vcpu = "${var.node-resources["vcpu"]}"
    memory = "${var.node-resources["memory"]}"

    cloudinit = "${element(libvirt_cloudinit.k8s-node.*.id, count.index)}"

    network_interface {
        network_id = "${libvirt_network.k8s-network.id}"
        wait_for_lease = 1
    }

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    disk {
        volume_id = "${element(libvirt_volume.k8s-node.*.id, count.index)}"
	}

    connection = {
        type = "ssh"
        user = "${var.base-volume["username"]}"
        private_key = "${var.ssh-provisioning-key}"
    }

    provisioner "file" {
        source = "./scripts/node.sh"
        destination = "/tmp/node.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/node.sh",
            "sudo -iu root /tmp/node.sh ${var.k8s-token} ${libvirt_domain.k8s-master.0.network_interface.0.addresses.0}",
        ]
    }
}

resource "null_resource" "deployments" {
    depends_on = [
        "libvirt_domain.k8s-master",
        "libvirt_domain.k8s-node",
    ]

    connection = {
        type = "ssh"
        host = "${libvirt_domain.k8s-master.0.network_interface.0.addresses.0}"
        user = "${var.base-volume["username"]}"
        private_key = "${var.ssh-provisioning-key}"
    }

    provisioner "file" {
        source = "./scripts/deployments.sh"
        destination = "/tmp/deployments.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/deployments.sh",
            "sudo -iu root /tmp/deployments.sh",
        ]
    }
}

# vim:ts=4:sw=4:et:
