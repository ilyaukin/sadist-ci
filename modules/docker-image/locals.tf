# describe how to build an image
# image name -> {"repo": [repo1, repo2], "dockerfile": "repo1/Dokcerfile"}...
locals {
  config = {
    webapp-flask = {
      repo = {
        0 = "ilyaukin/sadist-be"
        1 = "ilyaukin/sadist-fe"
      }
      dockerfile = "./sadist-be/Dockerfile-flask"
    }
    webapp-nginx = {
      repo = {
        0 = "ilyaukin/sadist-be"
      }
      dockerfile = "./sadist-be/Dockerfile-nginx"
    }
    certbot = {
      repo = {
        0 = "ilyaukin/sadist-be"
      }
      dockerfile = "./sadist-be/Dockerfile-certbot"
    }
    webapp-proxy = {
      repo = {
        0 = "ilyaukin/sadist-proxy"
      }
      dockerfile = "./sadist-proxy/Dockerfile-proxy"
    }
    blog-app = {
      repo = {
        0 = "ilyaukin/sadist-blog"
      }
      dockerfile = "./sadist-blog/Dockerfile-blog"
    }
    blog-admin-app = {
      repo = {
        0 = "ilyaukin/sadist-blog"
      }
      dockerfile = "./sadist-blog/Dockerfile-blog-admin"
    }
  }
  repo = local.config[var.name]["repo"]
  dockerfile = local.config[var.name]["dockerfile"]
}
