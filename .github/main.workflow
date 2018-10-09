# Plan Workflow
workflow "Terraform Plan" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://superbbears/filter:0.2.0"
  args = ["action", "opened|synchronize"]
}

action "terraform-fmt" {
  uses = "./fmt"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
}

action "terraform-init" {
  uses = "docker://hashicorp/terraform"
  args = ["init"]
  needs = "terraform-fmt"
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
