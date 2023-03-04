resource "google_compute_instance" "apache_instance" {
  name         = "apache-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2004-focal-v20230303"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
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

  #provisioner "file" {
  #  source      = "files/runcalc-main-app.service"
  #  destination = "/tmp/runcalc-main-app.service"
  #}

  #provisioner "remote-exec" {
  #  script = "files/deploy-main-app.sh"
  #}

  tags = [
    "apache-instance"
  ]
}