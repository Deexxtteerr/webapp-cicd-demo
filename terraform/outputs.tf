output "website_url" {
  description = "Website URL"
  value       = "http://${aws_s3_bucket.webapp.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.webapp.id
}

