resource "google_compute_instance" "haproxy_instance" {
  name         = "haproxy-instance"
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
    "haproxy-instance"
  ]
}

resource "google_compute_firewall" "firewall_80" {
  name     = "allow-80-default"
  # Название сети для которой действует правило
  network  = "default"
  # Какой доступ разрешаем
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  # кому разрешаем ходить 
  source_ranges = ["0.0.0.0/0"]
  # на какой тэг вешается правило
  target_tags = ["haproxy-instance"]
}