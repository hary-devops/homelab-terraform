


resource "docker_image" "app" {
  name = "nginx:latest"
}

resource "docker_container" "app" {
  name  = "my-container"
  image = docker_image.app.image_id

  ports {
    internal = 80
    external = 8333
  }
}
