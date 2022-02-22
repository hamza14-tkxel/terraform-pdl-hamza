resource "aws_kms_key" "s3_encryption_key" {
  description = "This key is used to encrypt all s3 bucket objects"
}
