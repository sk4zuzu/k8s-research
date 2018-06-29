
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
        private_key = "${file("ssh-provisioning-key")}"
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
    depends_on = [
        "libvirt_domain.k8s-master",
    ]

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
        private_key = "${file("ssh-provisioning-key")}"
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
        private_key = "${file("ssh-provisioning-key")}"
    }

    provisioner "file" {
        source = "./scripts/helm.sh"
        destination = "/tmp/helm.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/helm.sh",
            "sudo -iu root /tmp/helm.sh init",
            "sudo -iu root /tmp/helm.sh install",
        ]
    }
}

resource "null_resource" "kubeconfig" {
    depends_on = [
        "libvirt_domain.k8s-master",
        "null_resource.deployments",
    ]

    provisioner "local-exec" {
        command = <<-EOF
        rsync \
            -chavzP \
            --rsh='ssh -i ssh-provisioning-key -o StrictHostKeyChecking=no' \
            --rsync-path='sudo rsync' \
            $REMOTE:/etc/kubernetes/admin.conf \
            .
        EOF
        environment {
            REMOTE = "ubuntu@${libvirt_domain.k8s-master.0.network_interface.0.addresses.0}"
        }
    }
}

# vim:ts=4:sw=4:et:
