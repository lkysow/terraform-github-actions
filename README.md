# Terraform GitHub Actions
These official Terraform GitHub Actions allow you to run `terraform fmt`, `validate` and `plan` on your pull requests to help you review and validate Terraform changes.

### Terraform Fmt Action
Runs `terraform fmt` and comments back if any files are not formatted correctly.
<p align="center">
  <img src="./assets/fmt.png" alt="Terraform Fmt Action" width="80%" />
</p>

### Terraform Validate Action
Runs `terraform validate` and comments back on error.
<p align="center">
  <img src="./assets/validate.png" alt="Terraform Validate Action" width="80%" />
</p>

### Terraform Plan Action
Runs `terraform plan` and comments back with the output.
<p align="center">
  <img src="./assets/plan.png" alt="Terraform Plan Action" width="80%" />
</p>

# Usage
To add these actions to your pull requests, you can copy our [recommended workflow](#recommended-workflow) into your `.github/main.workflow` file or you can [write your own workflow](#compose-your-own-workflow).

## Recommended Workflow
This workflow will run `terraform fmt`, `init`, `validate` and `plan`. To use it:
1. Open up your repository in GitHub and click on the **Actions** tab
1. Click **Create a new workflow**
1. Click **<> Edit new file**
1. Paste the contents below into the file
1. If your Terraform is in a different directory that the root of your repo, then replace all instances of
    ```
    TF_ACTION_WORKING_DIR = "."
    ```
    With your directory, relative to the root of the repo, ex.
    ```
    TF_ACTION_WORKING_DIR = "./terraform"
    ```
    If you have multiple directories of Terraform code see [Multiple Terraform Directories](#multiple-terraform-directories)
1. Click back to the **Visual editor**
1. 

<details><summary>Show</summary>
  
```workflow
# .github/main.workflow
workflow "Terraform" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "docker://superbbears/filter:0.2.0"
  args = ["action", "opened|synchronize"]
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    # Set to the directory where your Terraform configuration lives.
    # Should be a relative path to the root of the repo, ex. ./mytfdir
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.1"
  needs = "terraform-fmt"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.1"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v0.1"
  needs = "terraform-validate"
  secrets = [
    "GITHUB_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "."
    # If you're using Terraform workspaces, set this to the workspace name.
    TF_ACTION_WORKSPACE = "default"
  }
}
```
</details>

# Compose Your Own Workflow
