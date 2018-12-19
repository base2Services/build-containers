workflow "Build Containers" {
  on = "push"
  resolves = [
    "Push Master",
    "Push Ref",
  ]
}

action "Build Serverless container" {
  uses = "actions/docker/cli@76ff57a"
  args = "build -t base2/serverless:build serverless/"
}

action "Docker Registry Login" {
  uses = "actions/docker/login@76ff57a"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
  needs = ["Build Serverless container"]
}

action "Tag" {
  uses = "actions/docker/tag@76ff57a"
  needs = ["Docker Registry Login"]
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

action "Push Ref" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Tag"]
  args = "push base2/serverless:${GITHUB_REF}"
}
