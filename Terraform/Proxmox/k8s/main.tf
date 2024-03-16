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
}

resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kube-server-0${count.index + 1}"
  target_node = var.proxmox_host
  vmid = "40${count.index + 1}"
  clone = var.template_name
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size = 20
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr17"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.98.1.4${count.index + 1}/24,gw=10.98.1.1"
  ipconfig1 = "ip=10.17.0.4${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-agent" {
  count = 3
  name = "kube-agent-0${count.index + 1}"
  target_node = "prox-1u"
  vmid = "50${count.index + 1}"

  clone = var.template_name

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size = 20
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr17"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.98.1.5${count.index + 1}/24,gw=10.98.1.1"
  ipconfig1 = "ip=10.17.0.5${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-storage" {
  count = 1
  name = "kube-storage-0${count.index + 1}"
  target_node = "prox-1u"
  vmid = "60${count.index + 1}"

  clone = "ubuntu-2004-cloudinit-template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size = 20
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr17"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.98.1.6${count.index + 1}/24,gw=10.98.1.1"
  ipconfig1 = "ip=10.17.0.6${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}

