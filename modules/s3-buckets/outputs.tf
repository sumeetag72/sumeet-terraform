output "finsemble_bucket_name" {
  description = "Bucket name where Finsemble is deployed"
  value       = aws_s3_bucket.finsemble.bucket
}