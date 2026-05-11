output "alb_dns" {
  value = aws_lb.app.dns_name
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
