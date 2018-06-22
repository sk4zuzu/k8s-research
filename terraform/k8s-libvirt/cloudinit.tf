
resource "libvirt_cloudinit" "k8s-cloudinit" {
    count = "${var.node-count}"
    name = "k8s-cloudinit.${count.index}.iso"
    local_hostname = "node${count.index}"
    ssh_authorized_key = "${ join("\n", values(var.ssh-authorized-keys)) }"
}

# vim:ts=4:sw=4:et:
