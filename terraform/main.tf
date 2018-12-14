variable "region"            {
}
variable "firehose_stream_name"    { }
variable "firehose_count"    { }
variable "log_group_name"    { }
variable "log_stream_name"   { }

variable "bucket_name" { }

provider "aws" {
  region = "${var.region}"
}
resource "aws_s3_bucket" "bucket" {
    bucket = "${var.bucket_name}"
}
resource "aws_iam_role" "firehose_role" {
   name = "firehose_example_role"
   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "firehose_role_policy" {
   name = "firehose_example_role_policy"
   role = "${aws_iam_role.firehose_role.id}"
   policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
EOF
}
resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.log_group_name}"
}
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.log_stream_name}"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
}
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  count = "${var.firehose_count}"
  name = "${var.firehose_stream_name}-${count.index + 1}"
  destination = "s3"
  s3_configuration {
    role_arn = "${aws_iam_role.firehose_role.arn}"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
    buffer_size = 5
    buffer_interval = 60
    cloudwatch_logging_options {
      enabled = "true"
      log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
      log_stream_name = "${aws_cloudwatch_log_stream.log_stream.name}"
    }
  }
}