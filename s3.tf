resource "aws_s3_bucket" "redshift" {
  bucket = var.s3_bucket_parquet
  acl    = "private"
}
