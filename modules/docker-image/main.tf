# if we build "flask", than frontend sources also
# have to be built and copied to the "flask" image
resource "null_resource" "build-frontend" {
  count    = var.name == "webapp-flask" ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/build-frontend.sh"
  }
}

# build and push the image
resource "null_resource" "build-image" {
  depends_on = [null_resource.build-frontend]
  triggers   = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/build-image.sh ${var.dockerfile} myhandicappedpet/${var.name}"
  }
}
