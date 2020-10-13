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
  use_minio = false
  nomad_datacenters = var.datacenters
  worker_memory = "8192"
  vault_policies = [ "default", "${var.workspace}-shared" ]
}
