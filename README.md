# Terraform GitHub Actions
These official Terraform GitHub Actions allow you to run `terraform fmt`, `validate` and `plan` on your pull requests to help you review and validate Terraform changes.

### Terraform Fmt Action
Runs `terraform fmt` and comments back if any files are not formatted correctly.
<img src="./assets/fmt.png" alt="Terraform Fmt Action" width="80%" />

### Terraform Validate Action
Runs `terraform validate` and comments back on error.
<img src="./assets/validate.png" alt="Terraform Validate Action" width="80%" />

### Terraform Plan Action
Runs `terraform plan` and comments back with the output.
<img src="./assets/plan.png" alt="Terraform Plan Action" width="80%" />

# Usage
To add these actions to your pull requests, you can copy our [recommended workflow](#recommended-workflow) into your `.github/main.workflow` file or you can [write your own workflow](#compose-your-own-workflow).

## Recommended Workflow
This workflow will run `terraform fmt`, `init`, `validate` and `plan`. To use it:

### Step 1 - Create the initial workflow
1. Open up your repository in GitHub and click on the **Actions** tab
1. Click **Create a new workflow**
1. Click **<> Edit new file**
1. Paste the contents below into the file
    <details><summary>Show</summary>
      
    ```workflow
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
      secrets = ["GITHUB_TOKEN"]
      env = {
        TF_ACTION_WORKING_DIR = "."
        # If you're using Terraform workspaces, set this to the workspace name.
        TF_ACTION_WORKSPACE = "default"
      }
    }
    ```
    </details>
   
### Step 2 - Customize it for your use-case
1. If your Terraform is in a different directory that the root of your repo, replace all instances of
    ```
    TF_ACTION_WORKING_DIR = "."
    ```
    With your directory, relative to the root of the repo, ex.
    ```
    TF_ACTION_WORKING_DIR = "./terraform"
    ```
    If you have multiple directories of Terraform code see [Directories](#directories)
1. If your Terraform runs in a different [workspace](https://www.terraform.io/docs/state/workspaces.html) than `default`, also change the `TF_ACTION_WORKSPACE` environment variable in the `terraform-plan` action.

   If you have multiple workspaces, see [Workspaces](#workspaces).
1. Click back to the **Visual editor**
1. If you're using a Terraform provider that requires credentials like AWS or Google Cloud Platform then you need to add those credentials as Secrets to the `terraform-plan` action. Secrets can only be added from the **Visual Editor** so click back to that tab.
1. Scroll down to the `terraform-plan` action and click **Edit**. This will open up the action editor on the right side where you'll be able to add your secrets, ex. `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. See your [Provider Documentation](https://www.terraform.io/docs/providers/) for how to use environment variables with your provider. 

    ⚠️ WARNING ⚠️ These secrets could be exposed if the plan action is run on a malicious Terraform file. As a result, we recommend you do not use this action on public repos or repos where untrusted users can submit pull requests.


# Compose Your Own Workflow
