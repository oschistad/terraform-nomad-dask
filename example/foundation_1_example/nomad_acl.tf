data "vault_generic_secret" "nomad_secret_id" {
  # Set count of this data source to 1 if ACLs are enabled in Nomad, and 0 if not
  count = var.nomad_acl ? 1 : 0
  path  = "nomad/creds/write"
}

provider "nomad" {
  address = "https://dsonv1-blue.nomad.service.blue.intern.minerva.loc:4646/ui/jobs/dask"
  # Add a secret_id if ACLs are enabled in nomad
  secret_id = var.nomad_acl ? data.vault_generic_secret.nomad_secret_id[0].data.secret_id : null
}


data "vault_generic_secret" "nomad_secret_id" {
  path = "nomad-minerva-${var.workspace}-nomad-server/creds/nomad-role"
}
