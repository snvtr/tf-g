provider "google" {
  project = "bots-378911"
  region  = "us-central1"
  zone    = "us-central1-c"
}

#terraform {
#  backend "gcs" {
#    bucket  = "bots-bucket-xxxxxxxxx"
#    prefix  = "terraform/state"
#  }
#}

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

/*
module "bucket" {
  source = "./modules/bucket"
}
*/
