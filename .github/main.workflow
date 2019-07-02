workflow "Build and Deploy to OpenShift" {
  on = "push"
  resolves = ["Test OC"]
}

# action "Build Image" {
#   uses = "actions/docker/tag@86ff551d26008267bb89ac11198ba7f1d807b699"
#   runs = "docker build -t beer-selector ."
# }

# action "Tag image" {
#   uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
#   runs = "docker tag beer-selector docker-registry.lab.pathfinder.gov.bc.ca/shea-argo/beer-selector:latest"
#   needs = ["Build Image"]
# }

# action "Auth to OpenShift registry" {
#   uses = "actions/docker/login@master"
#   needs = ["Tag image"]
#   secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME", "DOCKER_REGISTRY_URL"]
# }


# action "Push image" {
#   uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
#   runs = "docker push docker-registry.lab.pathfinder.gov.bc.ca/shea-argo/beer-selector:latest"
#   needs = ["Auth to OpenShift registry"]
# }


action "OpenShift Login" {
  uses = "stewartshea/jenkins2-with-docker@master"
  secrets = ["DOCKER_PASSWORD", "OPENSHIFT_URL"]  
#  needs = ["Push image"]

}

action "Test OC" {
  uses = "stewartshea/jenkins2-with-docker@master"
  secrets = ["DOCKER_PASSWORD", "OPENSHIFT_URL"] 
  runs = "oc get projects"
  needs = ["OpenShift Login"]

}
