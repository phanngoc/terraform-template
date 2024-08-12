#modules/store-layer/variables.tf
#5.
output "iac_standard_s3_codedeploy_bucket_id" {
  value = "${aws_s3_bucket.iac_standard_s3_codedeploy_bucket.id}"
}