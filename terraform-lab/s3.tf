
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "node-app-pipeline-test"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "ducpham-frontend-bucket"

}

resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.frontend.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.frontend.arn
        }
      }
    }]
  })
}
