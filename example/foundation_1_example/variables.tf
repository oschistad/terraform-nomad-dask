variable "nomad_acl" {
  default = "true"
}

variable "workspace" {
  description = "Foundation 1 workspace (prefix) used"
}

variable "datacenters" {
  type = list
  default = ["blue"]
}

