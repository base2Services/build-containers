workflow "Build Containers" {
  on = "push"
  resolves = [
    "Push Master",
    "Push Ref",
  ]
}

action "Build Serverless container" {
  uses = "actions/docker/cli@76ff57a"
  args = "build -t serverless serverless/"
}

action "Docker Registry Login" {
  uses = "actions/docker/login@76ff57a"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Tag" {
  uses = "actions/docker/tag@76ff57a"
  env = {
    CONTAINER_REGISTRY_PATH = "base2"
    IMAGE_NAME = "serverless"
  }
  args = ["$IMAGE_NAME", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
  needs = ["Docker Registry Login", "Build Serverless container"]
}

action "Push Ref" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Tag"]
  args = ["push", "base2/serverless:$GITHUB_REF"]
}

action "Master" {
  uses = "actions/bin/filter@e96fd9a"
  needs = ["Tag"]
  args = "branch master"
}

action "Tag Latest" {
  uses = "actions/docker/tag@76ff57a"
  needs = ["Master"]
  args = "build latest"
}

action "Push Master" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Tag Latest"]
  args = "push base2/serverless:latest"
}

