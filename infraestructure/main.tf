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
  lambda_name          = "cicdFunctionTest"
  handler              = "lambda_function.lambda_handler"
  runtime              = "python3.11"
  source_path          = "../src/lambda"
  layer_name           = "cicdLayerLambda"
  layer_initial_zip_path = "../src/venv/lib/python3.12/site-packages"
  role_name            = "cicdFunctionTestRole"
  layer_bucket            = "cicd-layer-repository"
}


module "cicd" {
  source                  = "./modules/cicd"
  lambda_name             = module.lambda_function.lambda_function_name
  build_project_name      = "cicdBuildTest"
  pipeline_name           = "cicdPipelineTest"
  artifact_bucket         = "cicd-arctifact-test-arthur"
  repository_name         = "aws-lambda-cicd-deploy"
  branch_name             = "main"
  codestar_connection_arn = "arn:aws:codeconnections:us-east-1:552516487395:connection/8a96bc9c-b145-48e3-a7ed-cff71f551f36"
  github_owner            = "arthurmeirelessm"
  github_oauth_token      =  var.github_oauth_token
  layer_name              = "cicdLayerLambda"
  aws_region              = "us-east-1"
  layer_bucket            = "cicd-layer-repository"
  aws_account_id          = "552516487395"
}
