terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

module "lambda_function" {
  source               = "./modules/app"
  lambda_function_name = "cicdFunctionTest"
  handler              = "lambda_function.lambda_handler"
  runtime              = "python3.11"
  source_path          = "../src"
  role_name            = "cicdFunctionTestRole"
}



module "cicd" {
  source                  = "./modules/cicd"
  lambda_name             = module.lambda_function.lambda_function_name
  lambda_function_name    = module.lambda_function.lambda_function_name
  build_project_name      = "cicdBuildTest"
  pipeline_name           = "cicdPipelineTest"
  artifact_bucket         = "cicd-arctifact-test-arthur"
  repository_name         = "aws-lambda-cicd-deploy"
  branch_name             = "main"
  codestar_connection_arn = "arn:aws:codeconnections:us-east-1:552516487395:connection/d19c0574-0023-4d2b-8ee3-37c1ef1d0b45"
  github_owner            = "arthurmeirelessm"
  github_oauth_token      = var.github_oauth_token
}
