resource "google_compute_instance" "control_instance" {
  name         = "control-instance"
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
    host  = google_compute_instance.control_instance.network_interface.0.access_config.0.nat_ip
    type  = "ssh"
    user  = "ubuntu"
    agent = false
    private_key = "${file("keys/id_rsa")}"
    timeout = "2m"
  }

  provisioner "file" {
    source      = "keys/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "ansible/"
    destination = "/tmp/"
  }

    provisioner "file" {
    source      = "files/"
    destination = "/tmp/"
  }

  #provisioner "file" {
  #  content     = templatefile("files/hosts.yaml.tpl", { APACHE = var.apache_ip, HAPROXY = var.haproxy_ip})
  #  destination = "/tmp/hosts.yaml"
  #}

  #provisioner "file" {
  #  content     = templatefile("files/haproxy.cfg.tpl", { APACHE = var.apache_ip, HAPROXY = var.haproxy_ip})
  #  destination = "/tmp/haproxy.cfg"
  #}

  provisioner "file" {
    content     = join("\n", var.apache_ip[*])
    destination = "/tmp/apache_out.txt"
  }

  provisioner "file" {
    content     = "${var.haproxy_ip}\n"
    destination = "/tmp/haproxy_out.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/do_all.sh",
      "/tmp/do_all.sh"
    ]
  }

  tags = [
    "control-instance"
  ]
}

#resource "local_file" "out" {
#  content  = "${var.apache_ip}\n${var.haproxy_ip}\n${google_compute_instance.control_instance.network_interface.0.network_ip}\n"
#  filename = "out"
#}