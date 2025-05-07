resource "aws_iam_role_policy_attachment" "build_policy" {
  role       = aws_iam_role.build_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_codebuild_project" "cicdFunctionTest_build" {
  name         = var.build_project_name
  service_role = aws_iam_role.build_role.arn


artifacts {
    type = "CODEPIPELINE"
  }


environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"



    environment_variable {
      name  = "lambda_function_name"
      value = var.lambda_function_name
    }
  }



source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
