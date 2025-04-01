provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy" "lambda_custom_policy" {
  name = "lambda_custom_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::*/*"
      }
    ]
  })
}


resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3sync.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::beeco-admin-images-test"
}




data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/s3sync"
  output_path = "${path.module}/../lambda/s3sync.zip"
}


resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = "beeco-admin-images-test"

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3sync.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""       # Optional: only trigger on specific folder
    filter_suffix       = ""       # Optional: only trigger on specific filetypes
  }

  depends_on = [aws_lambda_permission.allow_s3]
}


resource "aws_lambda_function" "s3sync" {
  function_name    = "s3sync_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}
