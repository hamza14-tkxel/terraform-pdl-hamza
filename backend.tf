terraform {
  cloud {
    organization = "paragon-data-lab"

    workspaces {
      name = var.terraform_workspace
    }
  }
}
