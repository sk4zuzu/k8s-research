
resource "libvirt_volume" "k8s-ubuntu-qcow2" {
    name = "k8s-ubuntu-qcow2"
    pool = "default"
    source = "${var.base-volume["source"]}"
    format = "qcow2"
}

resource "libvirt_volume" "k8s-volume" {
    count = "${var.node-count}"
    name = "k8s-volume.${count.index}"
    base_volume_id = "${libvirt_volume.k8s-ubuntu-qcow2.id}"
}

# vim:ts=4:sw=4:et:
