resource "nomad_job" "dask-fleet" {
  jobspec = file("${path.module}/conf/nomad/dask-fleet.hcl")
  detach  = false
}