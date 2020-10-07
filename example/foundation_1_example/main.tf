terraform {
  required_providers {
    nomad = {
      version = ">=1.4.0"
    }
  }
}
module "dask-fleet" {
  source = "../../."
  prefix = ""
  detach  = false
}
