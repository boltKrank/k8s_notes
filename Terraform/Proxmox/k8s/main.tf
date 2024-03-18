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

# VPC:
# gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

# Subnet:
# gcloud compute networks subnets create kubernetes \
#  --network kubernetes-the-hard-way \
#  --range 10.240.0.0/24

# Firewall rule 1:
# gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
#   --allow tcp,udp,icmp \
#   --network kubernetes-the-hard-way \
#   --source-ranges 10.240.0.0/24,10.200.0.0/16

# Firewall rule 2:
# gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external \
#   --allow tcp:22,tcp:6443,icmp \
#   --network kubernetes-the-hard-way \
#   --source-ranges 0.0.0.0/0


# k8s controllers

# for i in 0 1 2; do
#   gcloud compute instances create controller-${i} \
#     --async \
#     --boot-disk-size 200GB \
#     --can-ip-forward \
#     --image-family ubuntu-2004-lts \
#     --image-project ubuntu-os-cloud \
#     --machine-type e2-standard-2 \
#     --private-network-ip 10.240.0.1${i} \
#     --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
#     --subnet kubernetes \
#     --tags kubernetes-the-hard-way,controller
# done

resource "proxmox_vm_qemu" "kube-controller" {
  count = var.controller_count
  name = "kube-controller-0${count.index + 1}"
  target_node = var.proxmox_host
  vmid = "41${count.index + 1}"
  clone = var.template_name
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = var.controller_memory
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size = var.controller_hdd_size
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
    bridge = "vmbr10"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # The main LAN network is 10.98.1.0/24, and the Kube internal network (on its own bridge) is 10.20.0.0/24.

  # ipconfig0 = "ip=192.168.14${count.index + 1}/24,gw=192.168.20.1"
  # ipconfig1 = "ip=10.20.0.4${count.index + 1}/24"

  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}

# K8s workers (e2-standard-2 = 2 vCPU@2.25GHz, 8GB)
# for i in 0 1 2; do
#   gcloud compute instances create worker-${i} \
#     --async \
#     --boot-disk-size 200GB \
#     --can-ip-forward \
#     --image-family ubuntu-2004-lts \
#     --image-project ubuntu-os-cloud \
#     --machine-type e2-standard-2 \
#     --metadata pod-cidr=10.200.${i}.0/24 \
#     --private-network-ip 10.240.0.2${i} \
#     --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
#     --subnet kubernetes \
#     --tags kubernetes-the-hard-way,worker
# done


resource "proxmox_vm_qemu" "kube-worker" {
  count = var.worker_count
  name = "kube-worker-0${count.index + 1}"
  target_node = var.proxmox_host
  vmid = "51${count.index + 1}"

  clone = var.template_name

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = var.worker_memory
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size = var.worker_hdd_size
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge = var.k8s_bridge
  }
  
  network {
    model = "virtio"
    bridge = "vmbr10"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # The main LAN network is 192.168.0.0/24. gw=192.168.20.1, and the Kube internal network (on its own bridge) is 10.20.0.0/24.

  # ipconfig0 = "ip=192.168.15${count.index + 1}/24,gw=192.168.20.1"
  # ipconfig1 = "ip=10.20.0.5${count.index + 1}/24"

  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}
