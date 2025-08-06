job "localstack" {
  datacenters = ["dc1"]
  type = "service"

  group "default" {
    network {
      port "http" {
        static = 4566
      }
    }

    task "localstack" {
      driver = "docker"

      config {
        image = "localstack/localstack:latest"
        ports = ["http"]
        env = {
          SERVICES = "s3,sqs,dynamodb"
          DEBUG    = "1"
        }
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
