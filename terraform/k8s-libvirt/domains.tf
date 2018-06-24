
resource "libvirt_domain" "k8s-domain" {
    count = "${var.node-count}"
    name = "k8s-domain.${count.index}"

    vcpu = "${var.node-resources["vcpu"]}"
    memory = "${var.node-resources["memory"]}"

    cloudinit = "${element(libvirt_cloudinit.k8s-cloudinit.*.id, count.index)}"

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
        volume_id = "${element(libvirt_volume.k8s-volume.*.id, count.index)}"
	}

    connection = {
        type = "ssh"
        user = "${var.base-volume["username"]}"
        private_key = "${var.ssh-provisioning-key}"
    }

    provisioner "file" {
        source = "./scripts/"
        destination = "/tmp"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/*.sh",
            "sudo /tmp/${count.index == 0 ? "master" : "node"}.sh ${var.k8s-token} ${libvirt_domain.k8s-domain.0.network_interface.0.addresses.0}",
        ]
    }
}

# vim:ts=4:sw=4:et:
