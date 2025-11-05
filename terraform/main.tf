provider "aws" {
     region = var.aws_region
   }

   resource "aws_s3_bucket" "webapp" {
     bucket = var.bucket_name
   }

   resource "aws_s3_bucket_public_access_block" "webapp" {
     bucket = aws_s3_bucket.webapp.id
     
     block_public_acls       = false
     block_public_policy     = false
     ignore_public_acls      = false
     restrict_public_buckets = false
   }

   resource "aws_s3_bucket_policy" "webapp" {
     bucket = aws_s3_bucket.webapp.id
     
     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect    = "Allow"
           Principal = "*"
           Action    = "s3:GetObject"
           Resource  = "${aws_s3_bucket.webapp.arn}/*"
         }
       ]
     })
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

