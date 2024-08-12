resource "aws_s3_bucket" "artifact" {
  bucket        = "${var.project}-codebuild-${var.env}"
  force_destroy = true

  tags = {
    Name  = "${var.project}-codebuild-${var.env}"
    Stage = "${var.env}"
  }
}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.artifact.id
  acl    = "private"
}