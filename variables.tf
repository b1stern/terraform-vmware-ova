# General vCenter data
user = "Administrator@tivlab.raleigh.ibm.com" # vSphere User

password = "Ams49test!" # vSphere Password

vsphere_server = "vcenter1.tivlab.raleigh.ibm.com" # vSphere URL (IP, hostname or FQDN)

    {
      "name": "vm_1_datacenter",
      "type": "string",
      "description": "Target vSphere datacenter for virtual machine creation",
      "hidden": false,
      "default": "RTP",
      "label": "Target vSphere Datacenter",
      "secured": false,
      "required": false,
      "immutable": false,
      "group_name": "cloud"
    },

datacenter = "RTP" # vSphere datacenter

datastore = "v7000_vmware2_v6" # vSphere datastore

resource_pool = "Pool1" # vSphere Resourcepool

# Virtual Machine configuration
name = "ubuntuova" # name of the virtual machine

template = "ubuntu-bionic-18-04-cloudimg" # chosen name of the template

network = "VM Network" # network for the VM to reside in

cpus = 4 # CPU cores of the VM

memory = 8192 # Memory of the VM in Mb
