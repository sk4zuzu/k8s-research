
resource "libvirt_cloudinit" "k8s-master" {
    count = "${var.master-resources["count"]}"
    name = "k8s-master.${count.index}.iso"

    local_hostname = "master${count.index}"

    ssh_authorized_key = "${join("\n", values(var.ssh-authorized-keys))}"

    user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    EOF
}

resource "libvirt_cloudinit" "k8s-node" {
    count = "${var.node-resources["count"]}"
    name = "k8s-node.${count.index}.iso"

    local_hostname = "node${count.index}"

    ssh_authorized_key = "${join("\n", values(var.ssh-authorized-keys))}"

    user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    EOF
}

# vim:ts=4:sw=4:et:
