data "aws_iam_policy_document" "carla-s3-full-data" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "carla-s3-full" {
  name               = "carla-s3-full"
  assume_role_policy = data.aws_iam_policy_document.carla-s3-full-data.json
}

resource "aws_iam_role_policy_attachment" "carla-s3-full-attch" {
  role       = "aws_iam_role.carla-s3-full.name"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "carla-s3-full-profl" {
  name = "carla-s3-full-profl"
  role = aws_iam_role.carla-s3-full.name
}