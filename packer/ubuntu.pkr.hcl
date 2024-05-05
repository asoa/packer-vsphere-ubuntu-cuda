packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 1.2.7"
    }
  }
}

locals { 
  data_source_content = {
    "/meta-data" = file("${abspath(path.root)}/data/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password           = var.build_password
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      additional_packages      = var.additional_packages
      ssh_public_key           = var.ssh_public_key
      build_password_encrypted = var.build_password_encrypted
    })
    "/autoinstall.yaml" = templatefile("${abspath(path.root)}/data/autoinstall.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password           = var.build_password
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      additional_packages      = var.additional_packages
      ssh_public_key           = var.ssh_public_key
      build_password_encrypted = var.build_password_encrypted
    })
  }
}

source "vsphere-iso" "#{vm_name}#" {
  vcenter_server            = var.vcenter_server
  username                  = var.vcenter_username
  password                  = var.vcenter_password
  insecure_connection       = var.vcenter_insecure
  datacenter                = var.vcenter_datacenter
  cluster                   = var.vcenter_cluster
  folder                    = var.vcenter_folder
  datastore                 = var.vcenter_datastore
  vm_name                   = var.vm_name
  
  # vm settings
  guest_os_type             = var.vm_guestos_type
  firmware                  = var.vm_firmware
  CPUs                      = var.vm_cpu_sockets
  cpu_cores                 = var.vm_cpu_cores
  RAM                       = var.vm_mem_size
  CPU_hot_plug              = var.vm_cpu_hotadd
  RAM_hot_plug              = var.vm_mem_hotadd
  cdrom_type                = var.vm_cdrom_type
  remove_cdrom              = var.vm_cdrom_remove
  disk_controller_type      = var.vm_disk_controller


  # network adapter settings
  network_adapters {
    network                 = var.vcenter_network
    network_card            = var.vm_nic_type
  }

  # disk controller settings
  storage {
    disk_size               = var.vm_disk_size
    disk_thin_provisioned   = var.vm_disk_thin
  }

  // Removable Media Settings
  // cd_content = local.content
  // http_content = var.common_data_source == "http" ? local.data_source_content : null
  cd_content   = var.common_data_source == "disk" ? local.data_source_content : null
  // cd_files     = var.common_data_source == "disk" ? ["./packer/data/meta-data", "./packer/data/user-data"] : null
  cd_label     = var.common_data_source == "disk" ? "cidata" : null

  # iso settings
  iso_paths                 = [ "[${var.os_iso_datastore}] ${var.os_iso_path}/${var.os_iso_file}"]
  boot_order                = "disk,cdrom"
  boot_wait                 = "5s"
  
  boot_command = [
  "<wait3s>c<wait3s>",
  "linux /casper/vmlinuz --- autoinstall ds=nocloud;s=/cdrom", // Data source location for autoinstall files 
  "<enter><wait>",
  "initrd /casper/initrd",
  "<enter><wait>",
  "boot",
  "<enter>"
  ]

  ip_wait_timeout             = var.vm_ip_timeout
  ssh_timeout                 = "10m"
  communicator                = "ssh"
  ssh_username                = var.build_username
  ssh_password                = var.build_password
  shutdown_command            = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout            = var.vm_shutdown_timeout

  # content library settings
  create_snapshot          = var.create_snapshot
  snapshot_name            = var.snapshot_name
  convert_to_template      = var.convert_to_template
  content_library_destination {
    library                = var.vcenter_content_library
    name                   = "${source.name}"
    folder                 = var.vcenter_folder
    description            = var.description
    destroy                = var.destroy_vm
    ovf                    = var.import_ovf
    skip_import            = var.skip_import
  }

}

build {
  sources = ["source.vsphere-iso.#{vm_name}#"]

  // provisioner "shell" {
  //   execute_command = "echo '${var.build_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
  //   scripts = var.script_files
  // }

  provisioner "shell" {
    execute_command = "echo '${var.build_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "scripts/1-install_cuda_depends.sh"
    environment_vars = ["INSTALL_CUDA=${var.cuda_install_deps}]}"]
  }

  provisioner "shell" {
    # reboot
    expect_disconnect = true
    inline = ["sudo reboot"]
    pause_after = "10s"
  }

  provisioner "shell" {
    execute_command = "echo '${var.build_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "scripts/2-disable_nouveau.sh"
    pause_before = "15s"
    timeout = "2m"
  }

  # reboot
  provisioner "shell" {
    expect_disconnect = true
    inline = ["sudo reboot"]
    pause_after = "10s"
  }

  provisioner "shell" {
    execute_command = "echo '${var.build_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "scripts/3-install_cuda.sh"
    pause_before = "15s"
    timeout = "2m"
  }

  provisioner "shell" {
    # reboot
    expect_disconnect = true
    inline = ["sudo reboot"]
    pause_after = "10s"
  }  

  post-processor "manifest" {
        output              = "manifest.txt"
        strip_path          = true
        custom_data         = {
            vcenter_fqdn    = var.vcenter_server
            vcenter_folder  = var.vcenter_folder
            iso_file        = var.os_iso_file
        }
    }
}

