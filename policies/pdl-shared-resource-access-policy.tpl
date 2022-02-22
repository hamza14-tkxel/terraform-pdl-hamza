{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:aws:iam::${pdl_account_num}:role/code_artificat_cross_aws_access"
      ]
    }
  ]
}
