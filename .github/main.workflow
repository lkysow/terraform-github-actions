workflow "terraform-dir1" {
  resolves = "terraform-plan-dir1"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://superbbears/filter:0.2.0"
  args = ["action", "opened|synchronize"]
}

action "terraform-fmt-dir1" {
  uses = "./fmt"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "dir1"
  }
}

action "terraform-init-dir1" {
  uses = "./init"
  secrets = ["GITHUB_TOKEN"]
  needs = "terraform-fmt-dir1"
  env = {
    TF_ACTION_WORKING_DIR = "dir1"
  }
}

action "terraform-validate-dir1" {
  uses = "./validate"
  secrets = ["GITHUB_TOKEN"]
  needs = "terraform-init-dir1"
  env = {
    TF_ACTION_WORKING_DIR = "dir1"
  }
}

action "terraform-plan-dir1" {
  uses = "./plan"
  needs = "terraform-validate-dir1"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "dir1"
  }
}

workflow "terraform-dir2" {
  resolves = "terraform-plan-dir2"
  on = "pull_request"
}

action "terraform-fmt-dir2" {
  uses = "./fmt"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "dir2"
  }
}

action "terraform-init-dir2" {
  uses = "./init"
  secrets = ["GITHUB_TOKEN"]
  needs = "terraform-fmt-dir2"
  env = {
    TF_ACTION_WORKING_DIR = "dir2"
  }
}

action "terraform-validate-dir2" {
  uses = "./validate"
  secrets = ["GITHUB_TOKEN"]
  needs = "terraform-init-dir2"
  env = {
    TF_ACTION_WORKING_DIR = "dir2"
  }
}

action "terraform-plan-dir2" {
  uses = "./plan"
  needs = "terraform-validate-dir2"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "dir2"
  }
}
