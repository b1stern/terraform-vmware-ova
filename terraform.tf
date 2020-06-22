##############################################################
# Keys - CAMC (public/private) & optional User Key (public) 
##############################################################
variable "allow_unverified_ssl" {
  description = "Communication with vsphere server with self signed certificate"
  default     = "true"
}

##############################################################
# Define the vsphere provider 
##############################################################
provider "vsphere" {
  allow_unverified_ssl = var.allow_unverified_ssl
  version              = "~> 1.3"
}

provider "camc" {
  version = "~> 0.2"
}

data "vsphere_resource_pool" "vm_1_resource_pool" {
  name          = var.vm_1_resource_pool
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}

# General vCenter data
# vCenter / ESXi Username
variable "user" {
  default="Administrator@tivlab.raleigh.ibm.com"
}

# vCenter / ESXi Password
variable "password" {
  default="Ams49test!"
}

# vCenter / ESXi Endpoint
variable "vsphere_server" {
  default="vcenter1.tivlab.raleigh.ibm.com"
}

# vCenter / ESXi Datacenter
variable "datacenter" {
  default="RTP"
}

# vCenter / ESXi Datastore
variable "datastore" {
  default = "v7000_vmware2_v6"
}

# vCenter / ESXi ResourcePool
variable "vm_1_resource_pool" {
  default="Pool1"
}

# Virtual Machine configuration
# VM Name
variable "name" {
  default="http2"
}

# Name of OVA template (chosen in import process)
variable "template" {
  default="ubuntu-OVA"
}

# VM Network
variable "network" {
  default="VM Network"
}

# VM Number of CPU's
variable "cpus" {
  default="4"
}

# VM Memory in MB
variable "memory" {
  default="8192"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "http2"
#  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  resource_pool_id = data.vsphere_resource_pool.vm_1_resource_pool.id
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties {
      user-data = "${base64encode(file("cloud-init.yml"))}"
    }
  }

  clone {
#    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
}
