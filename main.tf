
locals {
  datacenters = join(",", var.nomad_datacenters)
}
resource "nomad_job" "dask_fleet" {
  jobspec = data.template_file.dask_job.rendered
  detach  = var.detach
}

data "template_file" "dask_job" {
  template = file("${path.module}/conf/nomad/dask-fleet.hcl")
  vars = {
    prefix = var.prefix
    workercount = var.workercount
    datacenters = local.datacenters
    minio_vault_key = var.minio.vault_key
    access_key = var.minio.access_key
    secret_key = var.minio.secret_key
    use_minio = var.use_minio
    minio_service = var.minio.service_name
    vault_policy = var.vault_policy
    memorysize = var.worker_memory
  }
}
