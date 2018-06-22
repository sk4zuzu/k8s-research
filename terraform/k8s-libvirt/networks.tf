
resource "libvirt_network" "k8s-network" {
    name = "k8s-network"
    domain = "k8s.local"
    addresses = [ "10.11.12.0/24" ]
}

# vim:ts=4:sw=4:et:
