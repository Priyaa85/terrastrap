# Module to build the Terraform S3 bootstrap for storing remote state

resource "aws_s3_bucket" "state_bucket" {
  # oak9: S3 bucket has no access control policy and is publicly available. Neither Public Access Block Configuration nor canned ACLs are defined.
  bucket = "${var.env}-${var.namespace}-${var.aws_region}-${var.tf_state_s3_bucket}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # oak9: server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm should be set to any of aws:kms
      }
    }
  }

  # Prevents Terraform from destroying this bucket
  lifecycle {
    prevent_destroy = true
  }
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
    Env       = var.env
    Bootstrap = "true"
  }
}

output "aws_s3_bucket_state_bucket_id" {
  value = aws_s3_bucket.state_bucket.id
}
