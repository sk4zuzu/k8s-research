
resource "libvirt_network" "k8s-network" {
    name = "k8s-network"
    domain = "${var.node-resources["domain"]}"
    addresses = [ "${var.node-resources["subnet"]}" ]
}

# vim:ts=4:sw=4:et:
