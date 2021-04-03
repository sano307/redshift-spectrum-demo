#----------------------------------------------------------
# Redshift
#----------------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy_for_redshift" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "arn:aws:redshift:ap-northeast-1:${data.aws_caller_identity.current.account_id}:dbuser:${var.redshift_cluster_identifier}/${var.redshift_master_username}"
      ]
    }
  }
}

data "aws_iam_policy_document" "redshift_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "glue:GetTable"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "redshift" {
  name               = "redshift-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_redshift.json
}

resource "aws_iam_role_policy" "redshift_role_policy" {
  name   = "redshift-role-policy"
  role   = aws_iam_role.redshift.id
  policy = data.aws_iam_policy_document.redshift_role_policy.json
}

#----------------------------------------------------------
# Glue
#----------------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy_for_glue" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "glue" {
  name               = "glue-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_glue.json
}

resource "aws_iam_role_policy" "glue_role_policy" {
  name   = "glue-role-policy"
  role   = aws_iam_role.glue.id
  policy = data.aws_iam_policy_document.glue_role_policy.json
}
