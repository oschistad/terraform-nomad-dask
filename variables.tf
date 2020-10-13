variable "prefix" {
  type = string
  default = ""
  description = "prefix to use in service-registration for nomad jobs"
}

variable "detach" {
  default = false
  description = "Run terraform job detached or wait for successful startup"
}

variable "workercount" {
  type = number
  default = 3
}
variable "use_minio" {
  type = bool
  default = false
  description = "Toggle MinIO integration for Dask. Also sets up credentials in local environment on workers if enabled"
}

variable "minio" {
  type = object({
    service_name = string,
    vault_key = string,
    access_key = string,
    secret_key = string
  })
  default = {
    service_name = "minio",
    vault_key = "secret/minio",
    access_key = "access_key",
    secret_key = "secret_key"
  }
  description = "Minio data"
}

variable "nomad_datacenters" {
  type        = list(string)
  description = "Nomad data centers"
  default     = ["dc1"]
}
variable "vault_policies" {
  default = [
    "base-server",
    "default"
  ]
  description = "List of policies to issue token from in Nomad job. Needs to have read access to minio.vault_key"
}

variable "worker_memory" {
  description = "RAM limit in MB for worker (enforced by Nomad)"
  type = number
  default = 512
}

variable "image" {
  description = "Container image for dask"
  default = "daskdev/dask:latest"
}

variable "zone" {
  default = ""
  description = "Network zone meta for contstraint tag. Requires a nomad server with same tag"
}
