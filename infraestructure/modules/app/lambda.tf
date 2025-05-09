resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_function_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.this.arn
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}


data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir = var.local_build_path
  output_path = "${path.module}/lambda.zip"
}



resource "aws_lambda_layer_version" "this_layer" {
  layer_name          = var.layer_name    # ex: "minha-layer"
  filename            = data.archive_file.layer_package.output_path
  compatible_runtimes = [var.runtime]    # ex: ["python3.12"]
  source_code_hash    = data.archive_file.layer_package.output_base64sha256
}


data "archive_file" "layer_package" {
  type        = "zip"
  source_dir  = var.local_build_path    
  output_path = "${path.module}/layer.zip"
}