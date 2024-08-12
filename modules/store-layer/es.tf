# Creating the Elasticsearch domain
 
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain_es
  elasticsearch_version = "7.10"

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  cluster_config {
    instance_count = 1
    instance_type  = "t2.small.elasticsearch"
  }

  vpc_options {
    subnet_ids = [var.subnet_ids[0]]
  }
  
#   tags = {
#     Domain = var.tag_domain
#   }
}

resource "aws_iam_service_linked_role" "es_role" {
  aws_service_name = "es.amazonaws.com"
}
 
# Creating the AWS Elasticsearch domain policy
 
resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.es.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.es.arn}/*"
        }
    ]
}
POLICIES
  depends_on = [aws_iam_service_linked_role.es_role]
}