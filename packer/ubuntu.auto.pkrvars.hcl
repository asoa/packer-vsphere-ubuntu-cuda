
vm_name                         = "#{vm_name}#"
build_username                  = "#{build_username}#"
build_password                  = "#{build_password}#"
build_password_encrypted        = "#{build_password_encrypted}#"
gitlab_access_token             = "#{gitlab_access_token}#"
# ISO Settings
os_iso_file                     = "ubuntu-22.04.4-live-server-amd64.iso"
os_iso_path                     = "ubuntu/22.04"
os_iso_datastore                = "nfs"

# OS Meta Data
vm_os_family                    = "linux"
vm_os_vendor                    = "ubuntu"
vm_os_version                   = "22.04-lts"

# VM Hardware Settings
vm_firmware                     = "efi"
vm_cpu_sockets                  = 4
vm_cpu_cores                    = 4
vm_mem_size                     = 4096
vm_nic_type                     = "vmxnet3"
vm_disk_controller              = ["pvscsi"]
vm_disk_size                    = 50000
vm_disk_thin                    = true
vm_cdrom_type                   = "sata"

# VM Settings
vm_cdrom_remove                 = true
vcenter_convert_template        = false
vcenter_content_library         = "mylibrary"
vcenter_content_library_ovf     = true
vcenter_content_library_destroy = true

# VM OS Settings
vm_guestos_type                 = "ubuntu64Guest"

# Provisioner Settings
script_files                    = [ "scripts/updates.sh",
                                    "scripts/install_cuda_depends.sh",
                                    "scripts/disable_nouveau.sh",
                                    "scripts/install_cuda.sh",
                                    "scripts/cleanup.sh" ]

# vSphere Settings
vcenter_username        = "#{vcenter_username}#"
vcenter_password        = "#{vcenter_password}#"
vcenter_server          = "192.168.4.205"
vcenter_datacenter      = "Datacenter"
vcenter_cluster         = "GEN 8 Cluster"
vcenter_folder          = "templates"
vcenter_datastore       = "nfs"
vcenter_network         = "ds_vm"

cuda_install_deps       = true
common_data_source      = "disk"
ssh_public_key          = "#{ssh_public_key}#"