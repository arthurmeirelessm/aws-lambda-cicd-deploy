resource "aws_codebuild_project" "cicdFunctionTest_build" {
  name         = var.build_project_name
  service_role = aws_iam_role.build_role.arn


artifacts {
    type = "CODEPIPELINE"
  }


environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"



   environment_variable {
      name  = "LAMBDA_FUNCTION_NAME"
      value = var.lambda_name
    }

    environment_variable {
      name  = "LAYER_NAME"
      value = var.layer_name
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name = "LAYER_BUCKET"
      value = var.layer_bucket
    }
  }


source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructure/modules/cicd/buildspec.yml"
  }
}
