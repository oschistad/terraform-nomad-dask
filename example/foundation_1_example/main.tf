terraform {
  required_providers {
    nomad = {
      version = ">=1.4.0"
    }
  }
}
module "dask-fleet" {
  source = "../../."
  prefix = "${var.workspace}-"
  detach = false
  minio = {
    service_name = "${var.workspace}-minio",
    vault_key = "secret/private/${var.workspace}-shared/minio",
    access_key = "accesskey",
    secret_key = "secretkey"
  }
  use_minio = true
  nomad_datacenters = var.datacenters
  vault_policy = "${var.workspace}-shared"
  worker_memory = "32768"
}
