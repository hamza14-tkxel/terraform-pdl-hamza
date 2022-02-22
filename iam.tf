
##################################################################### AWS Module managed policies ##############################################################
module "managed-policies" {
  source = "yukihira1992/managed-policies/aws"
}

data "aws_iam_policy" "ELB_full_access" {
  arn = module.managed-policies.ElasticLoadBalancingFullAccess
}

data "aws_iam_policy" "AEB_full_access" {
  arn = module.managed-policies.AmazonEventBridgeFullAccess
}

data "aws_iam_policy" "iam-code-deploy-full-access-data" {
  arn = module.managed-policies.AWSCodeDeployRole
}

data "template_file" "iam-common-perms-policy-data" {
  template = file("policies/common-perms-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-electra-db-access-policy-data" {
  template = file("policies/pdl-electra-db-access-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-ecr-access-policy-data" {
  template = file("policies/ecr-access-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-code-pipeline-access-policy-data" {
  template = file("policies/code-pipeline-access-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-cloud-watch-access-policy-data" {
  template = file("policies/cloud-watch-logs-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-cloud-watch-all-access-logs-policy-data" {
  template = file("policies/all-cloud-watch-logs-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

data "template_file" "iam-pdl-shared-resource-access-policy-data" {
  template = file("policies/pdl-shared-resource-access-policy.tpl")

  vars = {
    account_region  = var.account_region
    aws_account_num = var.aws_account_num
    env_name        = var.env
    client_code     = var.client_code
    pdl_account_num = var.pdl_account_num
  }
}

resource "aws_iam_policy" "iam-common-perms-policy" {
  name        = "${var.env}-common-perms-policy"
  policy      = data.template_file.iam-common-perms-policy-data.rendered
  description = "All access permissions for the ${var.env}. Used by the web application."
}

resource "aws_iam_policy" "iam-ecr-access-policy" {
  name        = "${var.env}-ecr-access-policy"
  policy      = data.template_file.iam-ecr-access-policy-data.rendered
  description = "All ECR access permissions for the ${var.env} repositories."
}

resource "aws_iam_policy" "iam-pdl-electra-db-access-policy" {
  name        = "${var.env}-pdl-electra-db-access-policy"
  policy      = data.template_file.iam-electra-db-access-policy-data.rendered
  description = "Access policy for the ${var.env} electra db policy."
}

resource "aws_iam_policy" "iam-pdl-shared-resource-access-policy" {
  name        = "${var.env}-pdl-shared-resource-access-policy"
  policy      = data.template_file.iam-pdl-shared-resource-access-policy-data.rendered
  description = "Access policy for the code-artifact domains to share binaries cross account."
}

resource "aws_iam_policy" "iam-code-pipeline-access-policy" {
  name        = "${var.env}-code-pipeline-access-policy"
  policy      = data.template_file.iam-code-pipeline-access-policy-data.rendered
  description = "Code-Pipeline access permissions for - ${var.env} pipeline."
}

resource "aws_iam_policy" "iam-cloud-watch-logs-policy" {
  name        = "${var.env}-cloud-watch-logs-policy"
  policy      = data.template_file.iam-cloud-watch-access-policy-data.rendered
  description = "Grants access to CloudWatch logs for the corresponding ${var.env} applications."
}

resource "aws_iam_policy" "iam-cloud-watch-all-access-logs-policy" {
  name        = "all-cloud-watch-logs-policy"
  policy      = data.template_file.iam-cloud-watch-all-access-logs-policy-data.rendered
  description = "Grants access to CloudWatch logs for all the environments."
}

########################################################################## IAM ROLES  ###################################################################################################

resource "aws_iam_instance_profile" "ec2-deploy-role" {
  name = "${var.env}-ec2-deploy-role"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role" "ec2-role" {
  name                 = "${var.env}-ec2-role"
  max_session_duration = var.role_max_session_duration
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "codebuild-service-role" {
  name = "code-build-${var.env}-${var.client_code}-cat-service-role"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
  max_session_duration = var.role_max_session_duration
}

resource "aws_iam_role" "code-deploy-ec2-role" {
  name = "code-deploy-${var.env}-${var.client_code}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ec2-sts-role" {
  name = "${var.env}-pdl-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

########################################################################## Roles <-> Policies Attachment  ###################################################################################################

resource "aws_iam_role_policy_attachment" "iam-ec2-role-ecr-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.iam-ecr-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-code-pipeline-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.iam-code-pipeline-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-elb-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = module.managed-policies.ElasticLoadBalancingFullAccess
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-event-bridge-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = module.managed-policies.AmazonEventBridgeFullAccess
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-perms-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.iam-common-perms-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-code-build-ecr-attach" {
  role       = aws_iam_role.codebuild-service-role.name
  policy_arn = aws_iam_policy.iam-ecr-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-code-build-pipeline-attach" {
  role       = aws_iam_role.codebuild-service-role.name
  policy_arn = aws_iam_policy.iam-code-pipeline-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-code-deploy-common-perms-attach" {
  role       = aws_iam_role.code-deploy-ec2-role.name
  policy_arn = aws_iam_policy.iam-common-perms-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-code-deploy-ec2-ecr-attach" {
  role       = aws_iam_role.code-deploy-ec2-role.name
  policy_arn = aws_iam_policy.iam-ecr-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-aws-elb-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = module.managed-policies.ElasticLoadBalancingFullAccess
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-aws-event-bridge-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = module.managed-policies.AmazonEventBridgeFullAccess
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-aws-code-deploy-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = module.managed-policies.AWSCodeDeployRole
}

resource "aws_iam_role_policy_attachment" "iam-ec2-role-code-pipeline-attach" {
  role       = aws_iam_role.code-deploy-ec2-role.name
  policy_arn = aws_iam_policy.iam-code-pipeline-access-policy.arn
}

########################################################################## User Groups  ###################################################################################################
resource "aws_iam_group" "iam-users-group" {
  name = "${var.env}-users"
}

resource "aws_iam_group" "iam-dev-ops-group" {
  name = "${var.env}-support-only"
}

resource "aws_iam_group" "iam-product-users-group" {
  name = "product-users"
}

resource "aws_iam_group" "iam-dev-engineers-only-group" {
  count = var.env == "dev" ? 1 : 0
  name  = "engineers-only"
  path  = "/users/"
}

resource "aws_iam_group" "iam-env-pdl-group" {
  name = "${var.env}-pdl"
  path = "/users/"
}

########################################################################## Groups <-> Policies Attachment  ###################################################################################################
resource "aws_iam_group_policy_attachment" "iam-users-group-common-perms-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-common-perms-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-users-group-ecr-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-ecr-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-pdl-electra-db-access-policy-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-pdl-electra-db-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-pdl-shared-resource-access-policy-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-pdl-shared-resource-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-users-group-pipeline-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-code-pipeline-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-users-group-cloud-watch-attach" {
  group      = aws_iam_group.iam-users-group.name
  policy_arn = aws_iam_policy.iam-cloud-watch-logs-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-electra-db-resource-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-pdl-electra-db-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-shared-resource-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-pdl-shared-resource-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-cloudwatch-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-cloud-watch-all-access-logs-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-ecr-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-ecr-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-pipeline-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-code-pipeline-access-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-engineers-only-common-perms-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-engineers-only-group[0].name
  policy_arn = aws_iam_policy.iam-common-perms-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-dev-ops-all-cloud-watch-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-dev-ops-group.name
  policy_arn = aws_iam_policy.iam-cloud-watch-all-access-logs-policy.arn
}

resource "aws_iam_group_policy_attachment" "iam-product-only-all-cloud-watch-attach" {
  count      = var.env == "dev" ? 1 : 0
  group      = aws_iam_group.iam-product-users-group.name
  policy_arn = aws_iam_policy.iam-cloud-watch-all-access-logs-policy.arn
}
