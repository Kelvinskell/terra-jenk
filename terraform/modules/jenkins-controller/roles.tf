# Create instance profile
resource "aws_iam_instance_profile" "server_profile" {
  name = "JenkinsControllerInstanceProfile"
  role = aws_iam_role.server_role.name

  tags = {
    Environment = "prod"
  }
}

# Define policy document
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "server_role" {
  name               = "JenkinsControllerRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "JenkinsControllerInlinePolicy"

    policy = jsonencode(
        {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:ModifySpotFleetRequest",
        "ec2:CreateTags",
        "ec2:TerminateInstances",
        "ec2:ModifyFleet",
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:UpdateAutoScalingGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:ListInstanceProfiles",
        "iam:ListRoles"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": [
            "ec2.amazonaws.com",
            "ec2.amazonaws.com.cn"
          ]
        }
      }
    }
  ]
}
    )
  }
}