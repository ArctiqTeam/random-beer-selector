workflow "New workflow" {
  on = "push"
  resolves = ["Docker Tag"]
}

action "Docker Tag" {
  uses = "actions/docker/tag@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker build -t beer-selector ."
}
