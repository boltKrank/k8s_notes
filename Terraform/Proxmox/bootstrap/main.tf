terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}


provider "proxmox" {


  pm_api_url = "https://192.168.20.15:8006/api2/json"

  pm_api_token_id = "terraform-prov@pve!terraform"
  
  pm_api_token_secret ="4d8f5171-f8cd-4531-b1db-37c8df480143"

  pm_tls_insecure = true

  pm_debug = true

}

resource "proxmox_vm_qemu" "bootstrap-vm" {

  name = "Bootstrap-vm"
  desc = "VM for bootstrapping"
  target_node = var.proxmox_host

  ## Clone from existing VM
  clone = "Ubuntu22ga"
  cores = 2
  sockets = 2


  
  
}