{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": [
        "arn:aws:secretsmanager:${account_region}:${pdl_account_num}:secret:electra-${env_name}-db-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ses:SendEmail",
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:${account_region}:${aws_account_num}:secret:${client_code}-cat-${env_name}*",
        "arn:aws:ses:${account_region}:${aws_account_num}:identity/*paragondatalabs.com"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:DescribeKey"
      ],
      "Resource": [
        "arn:aws:kms:us-east-*:${pdl_account_num}:key/mrk-*"
      ]
    }
  ]
}
