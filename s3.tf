locals {
  s3_tags = {
    "env"    = var.env
    "client" = var.client_code
  }
}

resource "aws_s3_bucket" "s3_engineering" {
  bucket = "pdl-engineering-only-${var.client_code}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = local.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_engineering" {
  bucket = aws_s3_bucket.s3_engineering.id

  count                   = var.env == "dev" ? 1 : 0
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for CICD
resource "aws_s3_bucket" "s3_cicd" {
  bucket = "pdl-cat-cicd-${var.client_code}-${var.env}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = local.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_cicd" {
  bucket = aws_s3_bucket.s3_cicd.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for external resources only
resource "aws_s3_bucket" "s3_ext" {
  bucket = "pdl-cat-ext-${var.client_code}-${var.env}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = local.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_ext" {
  bucket = aws_s3_bucket.s3_ext.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#  S3 bucket for environment
resource "aws_s3_bucket" "s3_env" {
  bucket = "pdl-cat-${var.client_code}-${var.env}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = local.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_env" {
  bucket = aws_s3_bucket.s3_env.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# s3 bucket for electra objects
resource "aws_s3_bucket" "s3_electra_env" {
  bucket = "pdl-electra-data-${var.client_code}-${var.env}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = local.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_electra_env" {
  bucket = aws_s3_bucket.s3_electra_env.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

