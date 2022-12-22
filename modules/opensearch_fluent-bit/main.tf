resource "aws_opensearch_domain" "example" {
  domain_name    = var.domain_name
  engine_version = var.opensearch_version

  cluster_config {
    instance_type = var.instance_type
  }

  tags = {
    Domain = "TestDomain"
  }
}