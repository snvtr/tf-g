resource "random_id" "for_bucket" {
  byte_length = 8
}

resource "google_storage_bucket" "static" {
  project       = "bots-378911"
  name          = "bots-bucket-${random_id.for_bucket.hex}"
  location      = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  prevent_destroy = true
}

#resource "google_storage_bucket_object" "default" {
#  name         = "tf-g state"
#  source       = "terraform.tfstate"
#  content_type = "text/plain"
#  bucket       = google_storage_bucket.static.id
#}