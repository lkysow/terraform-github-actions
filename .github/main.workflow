# Plan Workflow
workflow "Terraform Plan" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://bkeepers/actions-filter"
  args = ["action", "opened|synchronize"]
}

action "terraform-validate" {
  uses = "./validate"
  needs = "filter-to-pr-open-synced"
}

action "terraform-fmt" {
  uses = "./fmt"
  needs = "terraform-validate"
}

action "terraform-init-pr" {
  uses = "docker://hashicorp/terraform"
  args = ["init"]
  needs = "terraform-fmt"
}

action "terraform-plan" {
  uses = "./plan"
  needs = "terraform-init-pr"
  secrets = ["GITHUB_TOKEN"]
}
