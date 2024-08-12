data "template_file" "iac_standard_assume_role_codedeploy" {
  template = "${file("${path.module}/iam-role-temp/assume-role-codedeploy.json")}"
}
