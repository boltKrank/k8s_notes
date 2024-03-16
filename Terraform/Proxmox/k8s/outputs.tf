output "bootstrap_vm_ip" {
    description = "The IP of the machine provisioned"
    value = proxmox_vm_qemu.bootstrap-vm.default_ipv4_address
}

