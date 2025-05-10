resource "aws_codepipeline" "lambda_pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.pipeline_role.arn
  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }



stage {
  name = "Source"

  action {
    name             = "Source"
    category         = "Source"
    owner            = "AWS"
    provider         = "CodeStarSourceConnection"
    version          = "1"
    output_artifacts = ["source_output"]

    configuration = {
      ConnectionArn     = var.codestar_connection_arn
      FullRepositoryId  = "${var.github_owner}/${var.repository_name}"
      BranchName        = var.branch_name
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
        ProjectName = aws_codebuild_project.cicdFunctionTest_build.name
      }
    }
  }

}



