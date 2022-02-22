############################################################### Latest AMI for ec2 instance   ##############################################################################
data "aws_ami" "ubuntu" {
  most_recent = true
  tags = {
    Name = "build-on"
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-${var.ec2_os_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] #Canonical
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.client_code}-${var.env}-key"
  public_key = tls_private_key.tls_key.public_key_openssh
}


#################################################################     EC2   ######################################################################
resource "aws_instance" "ec2-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_family_type
  associate_public_ip_address = "true"
  key_name                    = aws_key_pair.generated_key.key_name
  subnet_id                   = aws_subnet.public-1.id
  iam_instance_profile        = aws_iam_instance_profile.ec2-deploy-role.name
  vpc_security_group_ids      = [aws_security_group.vpc_sg.id]


  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = "true"
  }

  tags = {
    env    = "${var.env}-ec2-disclosures"
    client = var.client_code
    app    = "cat-disclosures-ec2"
    Name   = "${var.env}-cat-disclosures-ec2"
  }

  depends_on = [
    aws_iam_instance_profile.ec2-deploy-role,
    aws_security_group.vpc_sg,
    data.aws_ami.ubuntu
  ]
}
