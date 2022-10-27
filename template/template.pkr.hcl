packer {
  required_plugins {
    parallels = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
  }
}

locals {
  build_directory = "${path.root}/../builds"
  http_directory  = "${path.root}/http"
  name            = "elx91_aarch64"
}

source "parallels-iso" "elx91_aarch64" {
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/el9/ks.cfg",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  boot_wait              = "5s"
  http_directory         = "http"
  guest_os_type          = "rhel"
  iso_checksum           = "dc35c068bd3906f7f82faecdb1ddf3f10d91c11fde6bb92f8778558264503897"
  iso_url                = "file:/Volumes/iso/el-9.1-beta/rhel-baseos-9.1-beta-1-aarch64-dvd.iso"
  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'ansible' | sudo -S shutdown -P now"
  ssh_password           = "ansible"
  ssh_timeout            = "900s"
  ssh_username           = "ansible"
}

build {
  sources = ["source.parallels-iso.elx91_aarch64"]

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/root", "IMAGE_NAME='${local.name}'", "BUILD_ID='${local.name}'", "DOCUMENTATION_URL='https://github.com/xtalcloud/system-image'"]
    execute_command   = "sh -euxc '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    remote_folder     = "/root"
    scripts           = ["${path.root}/scripts/motd.sh", "${path.root}/scripts/issue.sh", "${path.root}/scripts/metadata.sh", "${path.root}/scripts/sshd.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/configure_vim.sh", "${path.root}/scripts/install_fzf.sh", "${path.root}/scripts/install_nnn.sh", "${path.root}/scripts/configure_zsh.sh", "${path.root}/scripts/configure_tmux.sh", "${path.root}/scripts/install_bat.sh", "${path.root}/scripts/install_croc.sh", "${path.root}/scripts/install_fd.sh", "${path.root}/scripts/install_lnav.sh", "${path.root}/scripts/install_rg.sh", "${path.root}/scripts/install_z.sh", "${path.root}/scripts/cleanup.sh", "${path.root}/scripts/minimize.sh"]
  }

}
