workflow "Build and Deploy to OpenShift" {
  on = "push"
  resolves = ["Push image"]
}

action "Build Image" {
  uses = "actions/docker/tag@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker build -t beer-selector ."
}

action "Tag image" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker tag beer-selector docker-registry.lab.pathfinder.gov.bc.ca/shea-argo/beer-selector:latest"
  needs = ["Build Image"]
}

action "Auth to OpenShift registry" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker login -u $DOCKER_USER -p $DOCKER_PASSWORD docker-registry.lab.pathfinder.gov.bc.ca"
  needs = ["Tag image"]
  env = {
    DOCKER_REGISTRY_URL = "docker-registry.lab.pathfinder.gov.bc.ca"
    }
  secrets = ["DOCKER_PASS"]
}


action "Push image" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker push docker-registry.lab.pathfinder.gov.bc.ca/shea-argo/beer-selector:latest"
  needs = ["Auth to OpenShift registry"]
}
