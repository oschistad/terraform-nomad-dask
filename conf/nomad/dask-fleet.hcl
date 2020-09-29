job "dask" {
  datacenters = ["dc1"]
  group "scheduler" {
    network {
      mode = "bridge"
    }

    service {
      name = "dask-scheduler"
      port = "8786"

      connect {
        sidecar_service {}
      }
    }
    service {
      name = "dask-diag"
      port = "8787"

      connect {
        sidecar_service {}
      }
    }

    task "scheduler" {
      driver = "docker"
      config {
        image = "daskdev/dask"
      }
    }
  }

  group "worker" {
    network {
      mode ="bridge"
    }

    service {
      name = "dask-worker"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "dask-scheduler"
              local_bind_port = 8786
            }
          }
        }
      }
    }
    task "worker" {
      driver = "docker"
      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }
      config {
        image = "daskdev/dask"
        command = "dask-worker"
        args = [
          "tcp://localhost:8786"
        ]
      }
    }
  }
}
