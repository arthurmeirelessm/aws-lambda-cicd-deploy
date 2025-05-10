resource "aws_iam_role" "pipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "codepipeline-policy"
  role = aws_iam_role.pipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "codebuild:*",
          "codedeploy:*",
          "iam:PassRole",
          "lambda:*",
          "codestar-connections:UseConnection",
          "codestar-connections:StartOAuthHandshake",
          "codestar-connections:GetInstallationUrl",
          "codestar-connections:GetConnection"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "build_role" {
  name = "codebuild-cicd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "build_role_policy" {
  name = "codebuild-lambda-cloudwatch-policy"
  role = aws_iam_role.build_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "LambdaAndCloudWatchAccess",
        Effect = "Allow",
        Action = [
          "lambda:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
        ],
        Resource = "*"
      }
    ]
  })
}
