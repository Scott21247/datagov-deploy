variable "bucket" {
  description = "S3 bucket name to store your terraform state"
  type = "string"
  default = "adb-dev-tf"
}

provider "aws" {
  region = ""
}

resource "aws_s3_bucket" "state_backend" {
  bucket = "${var.bucket}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
