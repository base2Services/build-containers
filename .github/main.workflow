workflow "Build Containers" {
  on = "push"
  resolves = ["Push Latest"]
}

action "Build Serverless container" {
  uses = "actions/docker/cli@76ff57a"
  secrets = ["GITHUB_TOKEN"]
  args = "docker build -t base2/serverless serverless/"
}

action "Docker Registry Login" {
  uses = "actions/docker/login@76ff57a"
  secrets = ["DOCKER_LOGIN", "DOCKER_PASSWORD"]
  needs = ["Build Serverless container"]
}

action "Tag" {
  uses = "actions/docker/tag@76ff57a"
  args = "base2/serverless"
  needs = ["Docker Registry Login"]
}

action "Push Latest" {
  uses = "actions/docker/cli@76ff57a"
  args = "docker push base2/serverless"
  needs = ["Tag"]
}
