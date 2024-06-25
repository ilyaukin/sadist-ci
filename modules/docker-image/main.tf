# prepare home to our image in the AWS registry
resource "aws_ecr_repository" "main" {
  name                 = "myhandicappedpet/${var.name}"
  image_tag_mutability = "MUTABLE"
}

# set up rotation of the images
resource "aws_ecr_lifecycle_policy" "main" {
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "keep last 10 images"
        action       = {
          type = "expire"
        }
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
      }
    ]
  })
  repository = aws_ecr_repository.main.name
}

# check out all needed sources
resource "null_resource" "checkout" {
  for_each = local.config[var.name]["repo"]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/git-clone.sh ${each.value}"
  }
}

# if we buil
# if we build "flask", than frontend sources also
# have to be built and copied to the "flask" image
resource "null_resource" "build-frontend" {
  count      = var.name == "webapp-flask" ? 1 : 0
  depends_on = [null_resource.checkout]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/build-frontend.sh"
  }
}

# build and push the image
resource "null_resource" "build-image" {
  depends_on = [aws_ecr_repository.main, null_resource.checkout, null_resource.build-frontend]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "./bin/build-image.sh ${local.config[var.name]["dockerfile"]} ${aws_ecr_repository.main.repository_url} myhandicappedpet/${var.name}"
  }
}
