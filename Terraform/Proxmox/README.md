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

terraform destroy -auto-approve; terraform apply -auto-approve

https://github.com/Telmate/terraform-provider-proxmox/issues/922

Debugging:

export TF_LOG=debug

to turn off:

export TF_LOG=error

https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk

https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/ 


Creating template in proxmox from VM:

(https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/)

(https://yetiops.net/posts/proxmox-terraform-cloudinit-saltstack-prometheus/#terraform)

(https://github.com/deltxprt/proxmox-terraform)

```zsh
sudo qm create 9000 --name "ubuntu-2004-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
sudo qm importdisk 9000 focal-server-cloudimg-amd64.img local-zfs
sudo qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
sudo qm set 9000 --boot c --bootdisk scsi0
sudo qm set 9000 --ide2 local-zfs:cloudinit
sudo qm set 9000 --serial0 socket --vga serial0
sudo qm set 9000 --agent enabled=1
```