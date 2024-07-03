resource "null_resource" "checkout" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/git-clone.sh ${var.repo}"
  }
}
