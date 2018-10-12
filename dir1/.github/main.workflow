workflow "terraform-dir1" {
  resolves = "terraform-plan-dir1"
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
  uses = "./init"
  secrets = ["GITHUB_TOKEN"]
  needs = "terraform-fmt"
}

action "terraform-plan-dir1" {
  uses = "./plan"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
}
