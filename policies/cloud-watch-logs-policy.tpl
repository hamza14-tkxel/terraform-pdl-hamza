{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Get*",
        "logs:List*",
        "logs:StartQuery",
        "logs:StopQuery",
        "logs:Describe*",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents",
        "sns:Get*",
        "sns:List*",
        "logs:StartQuery"
      ],
      "Resource": [
        "arn:aws:logs:${account_region}:${aws_account_num}:log-group:/${env_name}*/*"
      ]
    }
  ]
}
