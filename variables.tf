variable "prefix" {
  type = string
  default = ""
  description = "prefix to use in service-registration for nomad jobs"
}

variable "detach" {
  default = false
  description = "Run terraform job detached or wait for success"
}

variable "workercount" {
  type = number
  default = 3
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
