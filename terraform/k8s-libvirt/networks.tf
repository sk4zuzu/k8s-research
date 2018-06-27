
resource "libvirt_network" "k8s-network" {
    name = "k8s-network"
    domain = "${var.network["domain"]}"
    addresses = [ "${var.network["subnet"]}" ]
}

# vim:ts=4:sw=4:et:
