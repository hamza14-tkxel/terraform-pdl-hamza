{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:ListSecrets",
        "ses:SendEmail",
        "logs:DisassociateKmsKey",
        "logs:DeleteSubscriptionFilter",
        "logs:DeleteLogGroup",
        "logs:StartQuery",
        "logs:CreateLogGroup",
        "logs:DeleteLogStream",
        "logs:PutLogEvents",
        "logs:CreateExportTask",
        "logs:PutMetricFilter",
        "logs:CreateLogStream",
        "logs:DeleteMetricFilter",
        "logs:DeleteRetentionPolicy",
        "logs:GetLogEvents",
        "logs:AssociateKmsKey",
        "logs:FilterLogEvents",
        "logs:PutSubscriptionFilter",
        "logs:PutRetentionPolicy",
        "logs:GetLogGroupFields"
      ],
      "Resource": [
        "arn:aws:secretsmanager:${account_region}:${aws_account_num}:secret:${client_code}-cat-${env_name}-*",
        "arn:aws:ses:${account_region}:${aws_account_num}:identity/*paragondatalabs.com",
        "arn:aws:logs:*:${aws_account_num}:log-group:/${env_name}/*",
        "arn:aws:logs:*:${aws_account_num}:log-group:/${env_name}/*:log-stream:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ses:SendEmail",
        "ses:SendRawEmail",
        "ses:SendBulkTemplatedEmail"
      ],
      "Resource": "arn:aws:ses:${account_region}:${aws_account_num}:identity/*paragondatalabs.com"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:GetLogRecord",
        "logs:PutDestinationPolicy",
        "logs:StopQuery",
        "logs:TestMetricFilter",
        "logs:DeleteDestination",
        "logs:DeleteQueryDefinition",
        "logs:PutQueryDefinition",
        "logs:GetLogDelivery",
        "logs:CreateLogDelivery",
        "logs:GetQueryResults",
        "logs:UpdateLogDelivery",
        "logs:CancelExportTask",
        "logs:DeleteLogDelivery",
        "logs:PutDestination",
        "sts:GetServiceBearerToken"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${account_region}:${aws_account_num}:log-group:/aws/codebuild/${env_name}-${client_code}-cat-*",
        "arn:aws:logs:${account_region}:${aws_account_num}:log-group:cat:/aws/codebuild/${env_name}-${client_code}-cat-*/*",
        "arn:aws:logs:${account_region}:${aws_account_num}:log-group:cat:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::pdl-cat-cicd-${client_code}-${env_name}",
        "arn:aws:s3:::pdl-cat-cicd-${client_code}-${env_name}/*",
        "arn:aws:s3:::pdl-${env_name}-cat-${client_code}/*",
        "arn:aws:s3:::pdl-${env_name}-cat-${client_code}",
        "arn:aws:s3:::pdl-engineering-only-${client_code}/*",
        "arn:aws:s3:::pdl-engineering-only-${client_code}"
      ]
    },
    {
      "Effect": "Deny",
      "Action": "s3:DeleteBucket",
      "Resource": [
        "arn:aws:s3:::pdl-${env_name}-cat-${client_code}",
        "arn:aws:s3:::pdl-cat-cicd-${client_code}-${env_name}",
        "arn:aws:s3:::pdl-engineering-only-${client_code}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
      ],
      "Resource": [
        "arn:aws:codebuild:${env_name}:${aws_account_num}:report-group/${env_name}-${client_code}-cat-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::codepipeline-${env_name}*"
      ]
    }
  ]
}
