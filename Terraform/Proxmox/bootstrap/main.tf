terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"    
    }
  }
}


provider "proxmox" {


  pm_api_url = var.pm_api_url

  pm_api_token_id = var.pm_api_token_id
  
  pm_api_token_secret = var.pm_api_token_secret

  pm_tls_insecure = true

  pm_debug = false

  pm_parallel = 10

}

resource "proxmox_vm_qemu" "bootstrap-vm" {

  name = var.bootstrap_vm_name
  desc = "VM for bootstrapping"
  target_node = var.proxmox_host

  ## Clone from existing VM
  clone = var.template_name
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 2
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  
  disks {
    scsi {
      scsi0 {
        disk {
          size = 30
          storage = "local-zfs"
        }
      }
    }
  }

  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall = false
    link_down = false
  }

  lifecycle {
    ignore_changes = [
      network, disk, sshkeys, target_node, ciuser
    ]
  }

  define_connection_info = true

  os_network_config = <<EOF
    auto eth0
    iface eth0 inet dhcp
  EOF



  ipconfig0 = "ip=192.168.20.91/24,gw=192.168.20.1"
  # ipconfig0 = "ip=dhcp"
  ciuser = var.ssh_user
  cipassword = var.ssh_user_password

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
  
  # provisioner "remote-exec" {
  #   inline = [ "ip a" ]    
  # }
  
}