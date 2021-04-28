data "aws_iam_policy_document" "carla-s3-ass-role-pol-doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect ="Allow"
    sid = ""
  }
}

resource "aws_iam_role" "carla-s3-role"{
  name               = "carla-s3-role"
  assume_role_policy = data.aws_iam_policy_document.carla-s3-ass-role-pol-doc.json
}

data "aws_iam_policy_document" "carla-s3-pol-doc" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    #resources = [aws_s3_bucket.bucket.arn]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "carla_s3_acc_pol" {
  name = "carla_s3_acc_pol"
  #role = aws_iam_role.carla-s3-role.id
  policy = data.aws_iam_policy_document.carla-s3-pol-doc.json
}

resource "aws_iam_role_policy_attachment" "carla-s3-role-pol-attch" {
  role       = aws_iam_role.carla-s3-role.name
  policy_arn = aws_iam_policy.carla_s3_acc_pol.arn
}

resource "aws_iam_instance_profile" "carla-ec2-s3-profl" {
  name = "carla-ec2-s3-profl"
  role = aws_iam_role.carla-s3-role.id
}