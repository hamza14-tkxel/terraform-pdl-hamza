# Main VPC
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env}-vpc"
    env  = var.env
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "env-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
    env  = var.env
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.env-igw.id
  }

  tags = {
    Name = "${var.env}-public-rtb"
    env  = var.env
  }
}

# Private Subnet with Default Route to NAT Gateway
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${join(".", slice(split(".", var.cidr_block), 0, 2))}.1.0/24"

  tags = {
    Name = "${var.env}-subnet-1"
    env  = var.env
  }
}

# Public Subnet with Default Route to Internet Gateway
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${join(".", slice(split(".", var.cidr_block), 0, 2))}.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-subnet-2"
    env  = var.env
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${join(".", slice(split(".", var.cidr_block), 0, 2))}.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-subnet-3"
    env  = var.env
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env}-private-rtb"
    env  = var.env
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count      = var.public_eip ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.env-igw]
  tags = {
    Name = "${var.env}-nat-gateway-eip"
    env  = var.env
  }
}


# Main NAT Gateway for VPC
resource "aws_nat_gateway" "nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private.id

  tags = {
    Name = "${var.env}-nat-gateway"
    env  = var.env
  }
}

resource "aws_security_group" "vpc_sg" {
  name        = "${var.env}-${var.client_code}-sg"
  description = "Security Group for the VPC - env: ${var.env} and client code: ${var.client_code}"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-${var.client_code}-sg"
    env  = var.env
  }
}

resource "aws_security_group_rule" "vpc_sg_https" {
  description       = "HTTPS Port"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.vpc_sg.id
}

resource "aws_security_group_rule" "vpc_sg_http" {
  description       = "HTTP Port"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.vpc_sg.id
}

resource "aws_security_group_rule" "vpc_sg_ssh" {
  description       = "SSH Port"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.vpc_sg.id
}

resource "aws_security_group_rule" "vpc_sg_mssql" {
  description       = "MS-SQL Port"
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.vpc_sg.id
}

resource "aws_security_group_rule" "vpc_sg_postgres" {
  description       = "PostgreSQL Port"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.vpc_sg.id
}

#Association between Public Subnet-1 and Public Route Table
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

#Association between Public Subnet-2 and Public Route Table
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

# Association between Private Subnet and Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
