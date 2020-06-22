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

data "vsphere_datacenter" "vm_1_datacenter" {
  name = var.vm_1_datacenter
}

data "vsphere_resource_pool" "vm_1_resource_pool" {
  name          = var.vm_1_resource_pool
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}






variable "vm_1_folder" {
  description = "Target vSphere folder for virtual machine"
  default     = "/RTP/vm/teraform"
}

variable "vm_1_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
  default = "RTP"
}

variable "vm_1_domain" {
  description = "Domain Name of virtual machine"
  default = "tivlab.raleigh.ibm.com"
}

variable "vm_1_number_of_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default     = "4"
}

variable "vm_1_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default     = "8192"
}

variable "vm_1_cluster" {
  description = "Target vSphere cluster to host the virtual machine"
  default     = "X3750"
}

variable "vm_1_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
  default     = "Pool1"
}

variable "vm_1_dns_suffixes" {
  type        = list(string)
  description = "Name resolution suffixes for the virtual network adapter"
  default     = ["tivlab.raleigh.ibm.com"]
}

variable "vm_1_dns_servers" {
  type        = list(string)
  description = "DNS servers for the virtual network adapter"
  default     = ["9.42.4.253"]
}

variable "vm_1_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
  default     = "VM Network"
}

variable "vm_1_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
  default     = "9.42.12.1"
}

variable "vm_1_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
}

variable "vm_1_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
  default     = "22"
}

variable "vm_1_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "vm_1_root_disk_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
  default     = "v7000_vmware2_v6"
}

variable "vm_1_root_disk_type" {
  type        = string
  description = "Type of template disk volume"
  default     = "thin"
}

variable "vm_1_root_disk_controller_type" {
  type        = string
  description = "Type of template disk controller"
  default     = "scsi"
}

variable "vm_1_root_disk_keep_on_remove" {
  type        = string
  description = "Delete template disk volume when the virtual machine is deleted"
  default     = "true"
}

variable "vm_1_root_disk_size" {
  description = "Size of template disk volume. Should be equal to template's disk size"
  default     = "40"
}

variable "vm_1-image" {
  description = "Operating system image id / template that should be used when creating the virtual image"
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
