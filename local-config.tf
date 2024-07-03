# describe how to build an image
# image name -> {"repo": [repo1, repo2], "dockerfile": "repo1/Dokcerfile"}...
locals {
  config = {
    webapp-flask = {
      repo       = ["ilyaukin/sadist-be", "ilyaukin/sadist-fe"]
      dockerfile = "./sadist-be/Dockerfile-flask"
    }
    webapp-nginx = {
      repo       = ["ilyaukin/sadist-be"]
      dockerfile = "./sadist-be/Dockerfile-nginx"
    }
    certbot = {
      repo       = ["ilyaukin/sadist-be"]
      dockerfile = "./sadist-be/Dockerfile-certbot"
    }
    webapp-proxy = {
      repo       = ["ilyaukin/sadist-proxy"]
      dockerfile = "./sadist-proxy/Dockerfile-proxy"
    }
    blog-app = {
      repo       = ["ilyaukin/sadist-blog"]
      dockerfile = "./sadist-blog/Dockerfile-blog"
    }
    blog-admin-app = {
      repo       = ["ilyaukin/sadist-blog"]
      dockerfile = "./sadist-blog/Dockerfile-blog-admin"
    }
  }
}
