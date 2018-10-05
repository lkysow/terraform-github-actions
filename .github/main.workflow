# Plan Workflow
workflow "Terraform Plan" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://bkeepers/actions-filter"
  args = ["action", "opened|synchronize"]
}

action "terraform-init-pr" {
  uses = "docker://hashicorp/terraform"
  args = ["init"]
  needs = "filter-to-pr-open-synced"
}

action "terraform-plan" {
  uses = "lkysow/moonstar/plan@master"
  needs = "terraform-init-pr"
  secrets = ["GITHUB_TOKEN"]
}


workflow "Terraform Apply" {
  resolves = "terraform-apply"
  on = "push"
}

action "filter-to-master" {
  uses = "docker://bkeepers/actions-filter"
  args = "branch master"
}

action "terraform-init-push" {
  uses = "docker://hashicorp/terraform"
  args = ["init"]
  needs = "filter-to-master"
}

action "terraform-apply" {
  uses = "docker://hashicorp/terraform"
  args = ["apply", "-auto-approve"]
  needs = "terraform-init-push"
}


