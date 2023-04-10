## ---------------------------------------------------------------------------------------------------------------------
## TERRAFORM CODE TO DEPLOY VM USING LIBVIRT MODULE
## This code will provision the number of VMs on vm_count, values for bridge, memory and vcpu are defined on this file,
## variables declaration with default values on variables.tf, actual variable values should be added to terraform.tfvars.
## More information here https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs
## ---------------------------------------------------------------------------------------------------------------------

## Configure the Libvirt provider
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@192.168.123.6/system"
}

## Create a new domain
module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.10.0"

  vm_hostname_prefix = var.vm_hostname_prefix
  vm_count           = 4
  bridge             = "br0"
  memory             = "2048"
  vcpu               = 1
  system_volume      = 20
  share_filesystem = {
    source   = "/tmp"
    target   = "tmp"
    readonly = false
    mode     = "mapped"
  }

  dhcp          = true
  ip_address    = var.ip_address
  ip_gateway    = var.ip_gateway
  ip_nameserver = var.ip_nameserver

  local_admin        = var.local_admin
  ssh_admin          = var.ssh_admin
  ssh_private_key    = var.ssh_private_key
  local_admin_passwd = var.local_admin_passwd
  ssh_keys           = var.ssh_keys
  time_zone          = "AST"
  os_img_url         = var.os_img_url
}

output "outputs" {
  value = module.vm
}
