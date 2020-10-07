job "${prefix}dask" {
  datacenters = ["${datacenters}"]
  group "scheduler" {
    network {
      mode = "bridge"
    }

    service {
      name = "${prefix}dask-scheduler"
      port = "8786"

      connect {
        sidecar_service {}
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
        image = "daskdev/dask:2.28.0"
        command = "dask-scheduler"
      }
    }
  }

  group "worker" {
    network {
      mode ="bridge"
    }
    count = "${workercount}"
    vault {
      policies = ["default", "minio_client"]
    }
    service {
      name = "${prefix}dask-worker"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${prefix}dask-scheduler"
              local_bind_port = 8786
            }
          }
        }
      }
    }
    task "worker" {
      driver = "docker"
      config {
        image = "daskdev/dask:2.28.0"
        command = "dask-worker"
        args = [
          "tcp://localhost:8786"
        ]
      }
      template {
        data = <<EOH
{{with secret "${minio_vault_key}"}}
AWS_ACCESS_KEY_ID="{{.Data.${access_key}}}"
AWS_SECRET_ACCESS_KEY="{{.Data.${secret_key}}}"
{{end}}
EOH

        destination = "secrets/minio.env"
        env         = true
      }
    }
  }
}
