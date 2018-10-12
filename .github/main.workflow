# Plan Workflow
workflow "Terraform Plan" {
  resolves = "terraform-plan"
  on = "push"
}

action "terraform-fmt" {
  uses = "./fmt"
  secrets = ["GITHUB_TOKEN"]
}

action "terraform-init" {
  uses = "./init"
  needs = "terraform-fmt"
  secrets = ["GITHUB_TOKEN"]
}

action "terraform-validate" {
  uses = "./validate"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
}

action "terraform-plan" {
  uses = "./plan"
  needs = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]
}
