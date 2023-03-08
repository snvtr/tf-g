resource "google_compute_instance" "apache_instance" {
  name         = "apache-instance-${count.index}"
  machine_type = "f1-micro"

  count = 2

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2004-focal-v20230303"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file("keys/id_rsa.pub")}"
  }

  connection {
    type  = "ssh"
    user  = "ubuntu"
    agent = false
    private_key = "${file("keys/id_rsa")}"
  }

  tags = [
    "apache-instance"
  ]
}
