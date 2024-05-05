variable "vm_name" {
  type    = string
}

variable "build_username" {
  type    = string
}

variable "build_password" {
  type    = string
}

variable "gitlab_access_token" {
  type    = string
}

variable "os_iso_file" {
  type    = string
}

variable "os_iso_path" {
  type    = string
  default = "ubuntu/22.04"
}

variable "os_iso_datastore" {
  type    = string
  default = "nfs"
}

variable "vm_os_family" {
  type    = string
  default = "Linux"
}

variable "vm_os_type" {
  type    = string
  default = "Server"
}

variable "vm_os_vendor" {
  type    = string
  default = "Ubuntu"
}

variable "vm_os_version" {
  type    = string
  default = "22.04"
}

variable "vm_firmware" {
  type    = string
  default = "efi"
}

variable "vm_cpu_sockets" {
  type    = number
  default = 2
}

variable "vm_cpu_cores" {
  type    = number
  default = 1
}

variable "vm_mem_size" {
  type    = number
  default = 2048
}

variable "vm_nic_type" {
  type    = string
  default = "vmxnet3"
}

variable "vm_disk_controller" {
  type    = list(string)
  default = ["pvscsi"]
}

variable "vm_disk_size" {
  type    = number
}

variable "vm_disk_thin" {
  type    = bool
  default = true
}

variable "vm_cdrom_type" {
  type    = string
  default = "sata"
}

variable "vm_cdrom_remove" {
  type    = bool
  default = true
}

variable "vcenter_convert_template" {
  type    = bool
  default = true
}

variable "vcenter_content_library" {
  type    = string
}

variable "vcenter_content_library_ovf" {
  type    = bool
  default = true
}

variable "vcenter_content_library_destroy" {
  type    = bool
  default = true
}

variable "vm_guestos_type" {
  type    = string
  default = "ubuntu64Guest"
}

variable "script_files" {
  type    = list(string)
  default = [
    "scripts/updates.sh",
    "scripts/install_openssh_server.sh",
    "scripts/enable_cloud_init.sh",
    "scripts/cleanup.sh"
  ]
}

variable "inline_cmds" {
  type    = list(string)
  default = []
}

variable "vcenter_username" {
  type    = string
}

variable "vcenter_password" {
  type    = string
}

variable "vcenter_server" {
  type    = string
}

variable "vcenter_datacenter" {
  type    = string
}

variable "vcenter_cluster" {
  type    = string
  default = "#{vcenter_cluster}#"
}

variable "vcenter_folder" {
  type    = string
}

variable "vcenter_datastore" {
  type    = string
}

variable "vcenter_network" {
  type    = string
}

variable "cuda_install_deps" {
  type    = bool
  default = true
}

variable "vm_mem_hotadd" {
  type    = bool
  default = true
}

variable "convert_to_template" {
  type    = bool
  default = true
}

variable "vcenter_insecure" {
  type    = bool
  default = true
}

variable "description" {
  type    = string
  default = "Ubuntu 22.04 Desktop"
}

variable "import_ovf" {
  type    = bool
  default = true
}

variable "skip_import" {
  type    = bool
  default = false
}

variable "destroy_vm" {
  type    = bool
  default = true
} 

variable "create_snapshot" {
  type    = bool
  default = false
} 

variable "vm_cpu_hotadd" {
  type    = bool
  default = true
} 

variable "snapshot_name" {
  type    = string
  default = "ubuntu-22.04-desktop"
}

variable "vm_ip_timeout" {
  type    = string
  default = "10m"
}

variable "vm_shutdown_timeout" {
  type    = string
  default = "10m"
}

variable "vm_boot_order" {
    type        = string
    description = "Set the comma-separated boot order for the VM (e.g. 'disk,cdrom')"
    default     = "disk,cdrom"
}
variable "vm_boot_wait" {
    type        = string
    description = "Set the delay for the VM to wait after booting before the boot command is sent (e.g. '1h5m2s' or '2s')"
    default     = "2s"
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en_US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "us"
}

variable "build_password_encrypted" {
  type        = string
  description = "The encrypted password to login the guest operating system."
  sensitive   = true
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

variable "additional_packages" {
  type        = list(string)
  description = "Additional packages to install."
  default     = []
}

variable "common_data_source" {
  type        = string
  description = "The provisioning data source. One of `http` or `disk`."
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key to use for authentication."
}
