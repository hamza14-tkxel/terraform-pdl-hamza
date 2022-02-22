{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:PutImageTagMutability",
        "ecr:UntagResource",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:TagResource",
        "ecr:UploadLayerPart",
        "ecr:ListImages",
        "ecr:InitiateLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "codebuild:*"
      ],
      "Resource": [
        "arn:aws:ecr:${account_region}:${aws_account_num}:repository/pdl-*",
        "arn:aws:ecr:${account_region}:${aws_account_num}:repository/${env_name}-*",
        "arn:aws:ecr:${account_region}:${aws_account_num}:repository/db-sync"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    }
  ]
}
