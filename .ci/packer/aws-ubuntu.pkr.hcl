packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-2204-e2e-runner-1"
  instance_type = "t3.xlarge"
  region        = "us-east-2"
  source_ami    = "ami-0aeb7c931a5a61206"
  ssh_username  = "ubuntu"
  communicator  = "ssh"
  tags = {
    OS_Version = "Ubuntu"
    Release    = "22.04"
    Arch       = "AMD64"
  }
  skip_create_ami = false
}

build {
  name = "e2e ubuntu 22.04 AMD64"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    user = "ubuntu"
    ansible_env_vars  =  ["PACKER_BUILD_NAME={{ build_name }}"]
    playbook_file     = ".ci/ansible/playbook.yml"
    extra_arguments   = ["--tags", "setup-ami"]
    galaxy_file       = ".ci/ansible/requirements.yml"
  }
}