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
      value = var.lambda_function_name
    }
  }



source {
    type      = "CODEPIPELINE"
    buildspec = "infraestructure/modules/cicd/buildspec.yml"
  }
}
