
resource "libvirt_volume" "k8s-ubuntu-qcow2" {
    name = "k8s-ubuntu-qcow2"
    pool = "default"
    source = "${var.base-volume["source"]}"
    format = "qcow2"
}

resource "libvirt_volume" "k8s-master" {
    depends_on = [
        "libvirt_volume.k8s-ubuntu-qcow2",
    ]

    count = "${var.master-resources["count"]}"
    name = "k8s-master.${count.index}"
    base_volume_id = "${libvirt_volume.k8s-ubuntu-qcow2.id}"
}

resource "libvirt_volume" "k8s-node" {
    depends_on = [
        "libvirt_volume.k8s-ubuntu-qcow2",
    ]

    count = "${var.node-resources["count"]}"
    name = "k8s-node.${count.index}"
    base_volume_id = "${libvirt_volume.k8s-ubuntu-qcow2.id}"
}

# vim:ts=4:sw=4:et:
