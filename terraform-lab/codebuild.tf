resource "aws_codebuild_project" "app" {
  name         = "node-app-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"

    privileged_mode = true
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/Sotatek-DucPham5/Test-CICD-AWS-native.git"

    buildspec = "buildspec.yml"
  }
}




resource "aws_codepipeline" "app" {
  name     = "node-app-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"

      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "Sotatek-DucPham5"
        Repo       = "Test-CICD-AWS-native"
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"

      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }
}
