terraform {
  cloud {
    organization = "Paragon-Data-Labs"

    workspaces {
      name = var.terraform_workspace
    }
  }
}
