{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::codepipeline-${env_name}*",
        "arn:aws:s3:::codepipeline-${env_name}*/*"
      ]
    },
    {
      "Effect": "Deny",
      "Action": "s3:DeleteBucket",
      "Resource": [
        "arn:aws:s3:::codepipeline-${env_name}*"
      ]
    }
  ]
}
