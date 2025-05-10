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
  function_name    = var.lambda_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.this.arn
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  layers = [aws_lambda_layer_version.this_layer.arn]
}


data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = var.local_source_path
  output_path = "${path.module}/lambda.zip"
}


resource "aws_lambda_layer_version" "this_layer" {
  layer_name          = var.layer_name
  s3_bucket           = aws_s3_bucket.layer_repository.id
  s3_key              = aws_s3_object.layer_zip.key
  compatible_runtimes = [var.runtime]
  source_code_hash    = data.archive_file.layer_package.output_base64sha256
}

data "archive_file" "layer_package" {
  type        = "zip"
  source_dir  = var.layer_initial_zip_path
  output_path = "${path.module}/layer.zip"
}



resource "aws_s3_bucket" "layer_repository" {
  bucket = "${var.layer_bucket}"
}


resource "aws_s3_object" "layer_zip" {
  bucket = aws_s3_bucket.layer_repository.id
  key    = "layers/python.zip"
  source = data.archive_file.layer_package.output_path
  etag   = filemd5(data.archive_file.layer_package.output_path)
}



