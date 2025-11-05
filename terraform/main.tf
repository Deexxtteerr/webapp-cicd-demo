provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "webapp" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "webapp" {
  bucket = aws_s3_bucket.webapp.id
  
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.webapp.id
  key          = "index.html"
  source       = "../src/index.html"
  content_type = "text/html"
}

