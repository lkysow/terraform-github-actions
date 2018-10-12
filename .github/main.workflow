workflow "terraform-workspace1" {
  resolves = "terraform-plan-workspace1"
  on       = "pull_request"
}

workflow "terraform-workspace2" {
  resolves = "terraform-plan-workspace2"
  on       = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://superbbears/filter:0.2.0"
  args = ["action", "opened|synchronize"]
}

action "terraform-fmt" {
  uses    = "./fmt"
  needs   = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
}

action "terraform-init" {
  uses    = "./init"
  secrets = ["GITHUB_TOKEN"]
  needs   = "terraform-fmt"
}

action "terraform-validate" {
  uses    = "./validate"
  secrets = ["GITHUB_TOKEN"]
  needs   = "terraform-init"
}

action "terraform-plan-workspace1" {
  uses    = "./plan"
  needs   = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]

  env = {
    TF_ACTION_WORKSPACE = "workspace1"
  }
}

action "terraform-plan-workspace2" {
  uses    = "./plan"
  needs   = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]

  env = {
    TF_ACTION_WORKSPACE = "workspace2"
  }
}
