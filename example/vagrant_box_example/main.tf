terraform {
  required_providers {
    nomad = {
      version = ">=1.4.0"
    }
  }
}
locals {
  nomad_namespace   = "default"
  nomad_datacenters = ["dc1"]
  vault_minio_creds_path = "secret/"
  minio_secret_key = "minioYeaaah"
  minio_access_key = "LoooongAssPassword2342342"
  minio_vault_path = "secret/minio"
}

module "dask-fleet" {
  source = "../../."
  prefix = ""
  detach  = false
//  minio = {
//    service_name = "minio"
//    vault_key = local.minio_vault_path
//  }
}


module "minio" {
  source = "github.com/fredrikhgrelland/terraform-nomad-minio.git?ref=0.1.0"

  # nomad
  nomad_datacenters               = ["dc1"]
  nomad_namespace                 = "default"
  nomad_host_volume               = "persistence"

  # minio
  service_name                    = "minio"
  host                            = "127.0.0.1"
  port                            = 9000
  container_image                 = "minio/minio:latest"
  access_key                      = local.minio_access_key
  secret_key                      = local.minio_secret_key
  data_dir                        = "/local/data"
  container_environment_variables = ["SOME_VAR_N1=some-value"]
  use_host_volume                 = false

  # minio client
  mc_service_name                 = "mc"
  mc_container_image              = "minio/mc:latest"
  buckets                         = ["one", "two"]
}

resource "vault_generic_secret" "minio_creds" {

  data_json = <<EOT
{
  "access_key":  "${local.minio_access_key}",
  "secret_key": "${local.minio_secret_key}"
}
EOT
  path = local.minio_vault_path
}

data "vault_policy_document" "minio_client" {
  rule {
    path         = "secret/data/minio"
    capabilities = [ "read", "list"]
    description  = "Allow reading of minio secrets"
  }
  rule {
    capabilities = ["list"]
    path = "secret/metadata/minio"
    description  = "Allow reading of minio secrets"
  }
}

resource "vault_policy" "minio_client" {
  name = "minio_client"
  policy = data.vault_policy_document.minio_client.hcl
}
