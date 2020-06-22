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

# provider "vsphere" {
#  user           = "Administrator@tivlab.raleigh.ibm.com"
#  password       = "Ams49test!"
#  vsphere_server = "vcenter1.tivlab.raleigh.ibm.com"

#  allow_unverified_ssl = true
#}

data "vsphere_datacenter" "dc" {
  name = "RTP"
}

data "vsphere_datastore" "datastore" {
  name          = "v7000_vmware2_v6"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "Pool1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-OVA"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "vsphere_virtual_machine" {
  description = "Virtual Machine OVA template"
  default = "ubuntu-OVA"
}

variable "vsphere_network" {
  description = "VMware Virtual Machine Network"
  default = "VM Network"
}

variable "vsphere_resource_pool" {
  description = "Resource Pool"
  default = "Pool1"
}

variable "vsphere_datastore" {
  description = "Target datastore"
  default = "v7000_vmware2_v5"
}

variable "vsphere_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
  default = "RTP"
}


resource "vsphere_virtual_machine" "vm" {
  name             = "http2"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
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
