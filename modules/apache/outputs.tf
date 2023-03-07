output "apache_ip" {
    #value = google_compute_instance.apache_instance.network_interface.0.network_ip
    value = google_compute_instance.apache_instance.*.network_interface.0.network_ip
}