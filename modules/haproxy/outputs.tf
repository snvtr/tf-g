output "haproxy_ip" {
    #value = google_compute_instance.haproxy_instance.network_interface.0.network_ip
    value = google_compute_instance.haproxy_instance.network_interface.0.access_config.0.nat_ip
}