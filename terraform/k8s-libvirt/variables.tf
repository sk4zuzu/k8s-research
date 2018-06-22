
variable "node-count" {
    default = 3
}

variable "base-volume" {
    default = {
        "source" = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
        "username" = "ubuntu"
    }
}

variable "ssh-provisioning-key" {
    default = <<-EOF
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACA0gDD2ujsNPnohAaZD6vzvJ+4DKZgDQ0nJ/5YcEL+VwgAAAJgthfL8LYXy
    /AAAAAtzc2gtZWQyNTUxOQAAACA0gDD2ujsNPnohAaZD6vzvJ+4DKZgDQ0nJ/5YcEL+Vwg
    AAAEAVUbyx3liAUH2qU5AGm+7L8bSwyyJM2tRXQJk8s7mfZDSAMPa6Ow0+eiEBpkPq/O8n
    7gMpmANDScn/lhwQv5XCAAAAEXJvb3RAOTM2YjFlNzFiY2JlAQIDBA==
    -----END OPENSSH PRIVATE KEY-----
    EOF
}

variable "ssh-authorized-keys" {
    default = {
        "provisioning"   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSAMPa6Ow0+eiEBpkPq/O8n7gMpmANDScn/lhwQv5XC provisioning"
        "prozac@rancher" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYG/4jbiwJuTXgsQq2Ao+UGfBNYp6CC48NDfwDOEndb prozac@rancher"
        "prozac@farmer"  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID16t0AGUQtCtG+hWQXv0/8qcD09HlODrft722Ji/5db prozac@farmer"
    }
}

# vim:ts=4:sw=4:et:
