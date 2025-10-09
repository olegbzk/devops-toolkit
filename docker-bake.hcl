
variable "IS_SEMVER" {
  default = "false"
}

variable "IMAGE_TAG" {
  default = "latest"
}

variable "IMAGE_NAME" {
  default = "devops-toolkit"
}

variable "REGISTRY" {
  default = "docker.io/rooibos75"
}

variable "BUILD_ARGS" {
  default = {}
}

function "set_tags" {
  params = [base_image_name]
  result = ["${REGISTRY}/${IMAGE_NAME}-${base_image_name}:${IMAGE_TAG}", "${IS_SEMVER == "true" ? "${REGISTRY}/${IMAGE_NAME}-${base_image_name}:latest" : ""}"]
}


group "default" {
  targets = ["ubuntu", "github-runner"]
}

target "ubuntu" {
  dockerfile = "Dockerfile.ubuntu"
  tags       = set_tags("ubuntu")
  args       = BUILD_ARGS
}

target "github-runner" {
  dockerfile = "Dockerfile.github-runner"
  tags       = set_tags("github-runner")
  args       = BUILD_ARGS
}
