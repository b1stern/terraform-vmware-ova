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
variable "resource_pool" {
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
