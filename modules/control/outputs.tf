output "apache_address" {
    value = var.apache_ip
}

output "haproxy_address" {
    value = var.haproxy_ip
}

output "control_address" {
    value = google_compute_instance.control_instance.network_interface.0.network_ip
}