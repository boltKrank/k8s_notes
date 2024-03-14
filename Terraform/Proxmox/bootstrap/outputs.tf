# locals {
#   k8s_server = "${zipmap("${proxmox_vm_qemu.k8s_server.*.name}", "${proxmox_vm_qemu.k8s_server.*.ipconfig0}")}"
#   k8s_agent  = "${zipmap("${proxmox_vm_qemu.k8s_agent.*.name}", "${proxmox_vm_qemu.k8s_agent.*.ipconfig0}")}"
#   storage    = "${zipmap("${proxmox_vm_qemu.storage.*.name}", "${proxmox_vm_qemu.storage.*.ipconfig0}")}"
#   puppet     = "${zipmap("${proxmox_vm_qemu.puppet.*.name}", "${proxmox_vm_qemu.puppet.*.ipconfig0}")}"

# }

# output "servers" {
#   value = "${merge("${local.k8s_server}", "${local.k8s_agent}", "${local.storage}", "${local.puppet}")}"
# }