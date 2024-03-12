# Terraform on Proxmox

## Pre-reqs

- Create a service account (see https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)

```zsh
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

Git bash works:

```zsh
export PM_USER="terraform-prov@pve"
export PM_PASS="password"
```

Debugging:

export TF_LOG=debug

to turn off:

export TF_LOG=error

https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk

https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/