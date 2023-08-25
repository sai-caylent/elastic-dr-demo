module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.1"

  bucket = "demo-edr-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
data "aws_iam_policy_document" "bucket_and_object_policy" {
  statement {
    sid       = "AllowBucketAccess"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::demo-edr-bucket"]
  }

  statement {
    sid = "AllowObjectAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::demo-edr-bucket/*"]
  }
}
resource "aws_iam_policy" "s3_access_policy" {
  name        = "EDRnetworkpolicy"
  description = "Policy for EDR to access S3 bucket and objects"

  policy = data.aws_iam_policy_document.bucket_and_object_policy.json
}
#####################################################################
## Cloud Endure Policy####
#####################################################################
data "aws_iam_policy_document" "cloud_endure" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["drs:DescribeSourceServers"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:drs:*:*:source-server/*"]

    actions = [
      "drs:UpdateAgentSourcePropertiesForDrs",
      "drs:GetLaunchConfiguration",
      "drs:UpdateLaunchConfiguration",
      "drs:BatchCreateVolumeSnapshotGroupForDrs",
      "drs:GetReplicationConfiguration",
      "drs:UpdateReplicationConfiguration",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeSnapshots",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:vpc/*"]
    actions   = ["ec2:CreateSecurityGroup"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    actions   = ["ec2:CreateSecurityGroup"]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/AWSElasticDisasterRecoveryManaged"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:launch-template/*"]

    actions = [
      "ec2:ModifyLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/AWSElasticDisasterRecoveryManaged"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:snapshot/*"]

    actions = [
      "ec2:CreateTags",
      "ec2:CopySnapshot",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/AWSElasticDisasterRecoveryManaged"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    actions = [
      "ec2:CreateTags",
      "ec2:CopySnapshot",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/AWSElasticDisasterRecoveryManaged"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:CreateGrant"]
  }
}

resource "aws_iam_policy" "cloud_endure" {
  name        = "CEDRAccessmentPolicy"
  description = "CLoud Endure Accessment Policy"

  policy = data.aws_iam_policy_document.cloud_endure.json
}
#####################################################################
## Policy for CloudEndure to EDR Upgrade
#####################################################################
resource "aws_iam_policy" "example_policy" {
  name        = "cloudendure_to_aws_edr_upgrade_policy"
  description = "cloudendure_to_aws_edr_upgrade_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "drs:DescribeSourceServers"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "drs:UpdateAgentSourcePropertiesForDrs",
          "drs:GetLaunchConfiguration",
          "drs:UpdateLaunchConfiguration",
          "drs:BatchCreateVolumeSnapshotGroupForDrs",
          "drs:GetReplicationConfiguration",
          "drs:UpdateReplicationConfiguration"
        ],
        "Resource" : "arn:aws:drs:*:*:source-server/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeSnapshots"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateSecurityGroup",
        "Resource" : "arn:aws:ec2:*:*:vpc/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateSecurityGroup",
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "Null" : {
            "aws:RequestTag/AWSElasticDisasterRecoveryManaged" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:ModifyLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion"
        ],
        "Resource" : "arn:aws:ec2:*:*:launch-template/*",
        "Condition" : {
          "Null" : {
            "aws:ResourceTag/AWSElasticDisasterRecoveryManaged" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags",
          "ec2:CopySnapshot"
        ],
        "Resource" : "arn:aws:ec2:*:*:snapshot/*",
        "Condition" : {
          "Null" : {
            "aws:RequestTag/AWSElasticDisasterRecoveryManaged" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags",
          "ec2:CopySnapshot"
        ],
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "Null" : {
            "aws:RequestTag/AWSElasticDisasterRecoveryManaged" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:CreateGrant"
        ],
        "Resource" : "*"
      }
    ]
  })
}
