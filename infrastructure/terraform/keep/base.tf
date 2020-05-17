## resouce names either have keep in the name, or an Environment = keep tag when applicable

# remote backend
## kms_key_id must be explicitly configured here
terraform {
  backend "s3" {
    bucket     = "terraform-backend-keep"
    key        = "state/keep"
    region     = "ca-central-1"
    encrypt    = "true"
    kms_key_id = "ab6d001a-e4ef-4702-aeb1-bf41fd865a17"
  }
}

# backend bucket
## encryption key
resource "aws_kms_key" "terraform-backend-bucket" {
  description             = "This key is used to encrypt bucket objects."
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform-backend-bucket" {
  name          = "alias/keep-terraform-backend-bucket"
  target_key_id = aws_kms_key.terraform-backend-bucket.id
}

## bucket
resource "aws_s3_bucket" "terraform-backend" {
  bucket = "terraform-backend-keep"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform-backend-bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "terraform-backend"
    Environment = "keep"
    Region      = "ca-central-1"
  }

}

# eth-account bucket
## encryption key
resource "aws_kms_key" "eth-accounts-bucket" {
  description             = "This key is used to encrypt bucket objects."
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "eth-accounts-bucket" {
  name          = "alias/keep-eth-accounts-bucket"
  target_key_id = aws_kms_key.eth-accounts-bucket.id
}

## bucket
resource "aws_s3_bucket" "eth-accounts" {
  bucket = "keep-eth-accounts"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.eth-accounts-bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "keep-eth-account"
    Environment = "keep"
    Region      = "ca-central-1"
  }

}

## bucket folders, one for each client
resource "aws_s3_bucket_object" "keep-beacon-client" {
  key        = "keep-beacon-client/"
  bucket     = aws_s3_bucket.eth-accounts.id
  source     = "/dev/null"
  kms_key_id = aws_kms_key.eth-accounts-bucket.arn
}

## bucket folders, one for each client type
resource "aws_s3_bucket_object" "keep-ecdsa-client" {
  key        = "keep-ecdsa-client/"
  bucket     = aws_s3_bucket.eth-accounts.id
  source     = "/dev/null"
  kms_key_id = aws_kms_key.eth-accounts-bucket.arn
}
