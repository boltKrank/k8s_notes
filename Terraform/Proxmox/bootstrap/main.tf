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
}

