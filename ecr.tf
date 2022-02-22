resource "aws_ecr_repository" "cat-fe" {
  name = "${var.env}-cat-fe"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "disclosures-app-server" {
  name = "${var.env}-disclosures-app-server"
  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "user-data-server" {
  name = "${var.env}-user-data-server"
  image_scanning_configuration {
    scan_on_push = true
  }
}
