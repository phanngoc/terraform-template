#Create s3 codedeploy-api bucket
resource "aws_s3_bucket" "iac_standard_s3_codedeploy_bucket" {
  bucket        = "${var.project}-codedeploy-${var.env}"
  force_destroy = true

  tags = {
    Name  = "${var.project}-codedeploy-${var.env}"
    Stage = "${var.env}"
  }
}

resource "aws_s3_bucket_acl" "codedeploy_bucket_acl" {
  bucket = aws_s3_bucket.iac_standard_s3_codedeploy_bucket.id
  acl    = "private"
}