terraform {
  cloud {
    organization = "dpopov"

    workspaces {
      name = "example-workspace"
    }
  }
}
