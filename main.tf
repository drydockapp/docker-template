terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
    host = "unix:///var/run/docker.sock"
}

resource "docker_volume" "storage" {
  name = "storage"
}

resource "docker_image" "main" {
  name = "dind-create"

  build {
    context = "./build"
    tag = ["dind-create:latest"]
  }
}

resource "docker_container" "workspace" {
  count = 1
  image = "dind-create:latest"
  name = "dind-test"
  hostname = "dind-test"
  command = ["/bin/sh", "-c", "sleep 2; docker compose -f /data/docker-compose.yml up -d; sleep infinity"]
  runtime = "sysbox-runc"
  rm = true
  
  networks_advanced {
    name = "caddy"
  }

  labels {
    label = "caddy"
    value = "datajet.soleimany.io"
  }

  labels {
    label = "caddy.reverse_proxy"
    value = "{{upstreams 5000}}"
  }

  ports {
    internal = 5000
    external = 5000
  }

  volumes {
    container_path = "/data"
    host_path = "/home/ben/drydock"
    read_only = false
  }
}
