# Test-CICD-AWS-native

# 

URL frontend: https://d6u8v890pftx5.cloudfront.net/index.html

URL backend:  http://node-app-alb-757853170.us-east-1.elb.amazonaws.com/api/health

App logic:

FE:

Cloudfront → S3

S3: lưu static file sau khi build

Backend: 

Cloudfront → ALB → ECS

Internet → IGW → Public subnet(VPC) → ALB → ÉCS Tasks

CI/CD: 

Codebuild + CodePipeline. Khi push code len github → Codebuild sẽ define buildspec.yml để thực hiện các step build code rồi deploy. CodePipeline detact các step và thực hiện:x

