job "${prefix}dask" {
  datacenters = ["${datacenters}"]
  group "scheduler" {
    network {
      mode = "bridge"
    }
    constraint {
      attribute = "$${meta.zone}"
      value = "dataplatform"
    }
    service {
      name = "${prefix}dask-scheduler"
      port = "8786"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${prefix}dask-worker1"
              local_bind_port = 8791
            }
            upstreams {
              destination_name = "${prefix}dask-worker2"
              local_bind_port = 8792
            }
            upstreams {
              destination_name = "${prefix}dask-worker3"
              local_bind_port = 8793
            }
          }
        }
      }
    }
    service {
      name = "${prefix}dask-diag"
      port = "8787"

      connect {
        sidecar_service {}
      }
    }

    task "scheduler" {
      driver = "docker"
      config {
        image = "${image}"
        command = "dask-scheduler"
      }
    }
  }

  group "worker1" {
    #https://distributed.dask.org/en/latest/worker.html
    network {
      mode ="bridge"
    }
    count = 1
    constraint {
      attribute = "$${meta.zone}"
      value = "dataplatform"
    }
%{ if use_minio }
    vault {
      policies = ["${vault_policies}"]
    }
%{endif}
    service {
      name = "${prefix}dask-worker1"
      port = "8791"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${prefix}dask-scheduler"
              local_bind_port = 8786
            }
            upstreams {
              destination_name = "${prefix}dask-worker2"
              local_bind_port = 8792
            }
            upstreams {
              destination_name = "${prefix}dask-worker3"
              local_bind_port = 8793
            }
%{ if use_minio }
            upstreams {
              destination_name = "${minio_service}"
              local_bind_port = 9000
            }
%{endif}
          }
        }
      }
    }
    task "worker" {
      driver = "docker"
      resources {
        memory = "${memorysize}"
      }
      config {
        image = "${image}"
        command = "dask-worker"
        args = [
          "--worker-port", "8791",
          "tcp://localhost:8786"
        ]
      }
%{ if use_minio }
      template {
        data = <<EOH
{{with secret "${minio_vault_key}"}}
AWS_ACCESS_KEY_ID="{{.Data.data.${access_key}}}"
AWS_SECRET_ACCESS_KEY="{{.Data.data.${secret_key}}}"
{{end}}
S3_ENDPOINT="127.0.0.1:9000"
EOH
        destination = "secrets/minio.env"
        env         = true
      }
%{endif}
    }
  }
  group "worker2" {
    #https://distributed.dask.org/en/latest/worker.html
    network {
      mode ="bridge"
    }
    count = 1
    constraint {
      attribute = "$${meta.zone}"
      value = "dataplatform"
    }
%{ if use_minio }
    vault {
      policies = ["${vault_policies}"]
    }
%{endif}
    service {
      name = "${prefix}dask-worker2"
      port = "8792"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${prefix}dask-scheduler"
              local_bind_port = 8786
            }
            upstreams {
              destination_name = "${prefix}dask-worker1"
              local_bind_port = 8791
            }
            upstreams {
              destination_name = "${prefix}dask-worker3"
              local_bind_port = 8793
            }
%{ if use_minio }
            upstreams {
              destination_name = "${minio_service}"
              local_bind_port = 9000
            }
%{endif}
          }
        }
      }
    }
    task "worker" {
      driver = "docker"
      resources {
        memory = "${memorysize}"
      }
      config {
        image = "${image}"
        command = "dask-worker"
        args = [
          "--worker-port", "8792",
          "tcp://localhost:8786"
        ]
      }
%{ if use_minio }
      template {
        data = <<EOH
{{with secret "${minio_vault_key}"}}
AWS_ACCESS_KEY_ID="{{.Data.data.${access_key}}}"
AWS_SECRET_ACCESS_KEY="{{.Data.data.${secret_key}}}"
{{end}}
S3_ENDPOINT="127.0.0.1:9000"
EOH
        destination = "secrets/minio.env"
        env         = true
      }
%{endif}
    }
  }
  group "worker3" {
    #https://distributed.dask.org/en/latest/worker.html
    network {
      mode ="bridge"
    }
    count = 1
    constraint {
      attribute = "$${meta.zone}"
      value = "dataplatform"
    }
%{ if use_minio }
    vault {
      policies = ["${vault_policies}"]
    }
%{endif}
    service {
      name = "${prefix}dask-worker3"
      port = "8793"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${prefix}dask-scheduler"
              local_bind_port = 8786
            }
            upstreams {
              destination_name = "${prefix}dask-worker1"
              local_bind_port = 8791
            }
            upstreams {
              destination_name = "${prefix}dask-worker2"
              local_bind_port = 8792
            }
%{ if use_minio }
            upstreams {
              destination_name = "${minio_service}"
              local_bind_port = 9000
            }
%{endif}
          }
        }
      }
    }
    task "worker" {
      driver = "docker"
      resources {
        memory = "${memorysize}"
      }
      config {
        image = "${image}"
        command = "dask-worker"
        args = [
          "--worker-port", "8793",
          "tcp://localhost:8786"
        ]
      }
%{ if use_minio }
      template {
        data = <<EOH
{{with secret "${minio_vault_key}"}}
AWS_ACCESS_KEY_ID="{{.Data.data.${access_key}}}"
AWS_SECRET_ACCESS_KEY="{{.Data.data.${secret_key}}}"
{{end}}
S3_ENDPOINT="127.0.0.1:9000"
EOH
        destination = "secrets/minio.env"
        env         = true
      }
%{endif}
    }
  }
}
