provider "google" {
  project = "bots-378911"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "apache" {
  source = "./modules/apache"
}

module "haproxy" {
  source = "./modules/haproxy"
}

module "control" {
  apache_ip  = module.apache.apache_ip
  haproxy_ip = module.haproxy.haproxy_ip
  source     = "./modules/control"
}
