# Terraform Validate Action
Runs `terraform validate` to validate the terraform files in a directory.
Validation includes a basic check of syntax as well as checking that all variables declared
in the configuration are specified in one of the possible ways:
* `-var foo=...`
* `-var-file=foo.vars`
* `TF_VAR_foo` environment variable
* `terraform.tfvars`
* default value

This action succeeds if `terraform validate` passes.

## Usage
NOTE: The `terraform validate` action will always fail unless `terraform init` is run first.

To run `terraform validate` on new and updated pull requests, create a `.github/main.workflow` file:
```workflow
# This workflow will run on pull request events.
workflow "Terraform Validate" {
  resolves = "terraform validate"
  on = "pull_request"
}

# We only run our actions on new or updated (synchronized) pull requests.
# This action ignores other pull request events.
action "filter-to-pr-open-or-synced" {
  uses = "docker://superbbears/filter:0.2.0"
  args = ["action", "opened|synchronize"]
}

# validate will always fail unless terraform init is run first.
action "terraform init" {
  uses = "docker://hashicorp/terraform"
  args = ["init"]
  needs = "filter-to-pr-open-or-synced"
}

# Now we can call validate.
action "terraform validate" {
  uses = "hashicorp/terraform-github-actions/validate@<latest tag>"
  needs = "terraform init"
}
```

## Environment Variables
| Name                    | Default | Description                                                                     |
|-------------------------|---------|---------------------------------------------------------------------------------|
| `TF_ACTION_WORKING_DIR` | `.`     | Which directory `terraform validate` runs in. Relative to the root of the repo. |

## Secrets
No secrets are required for `terraform validate`.

## Arguments
Arguments to `terraform validate` will be appended to the `terraform validate`
command:
```workflow
action "terraform validate" {
  uses = "hashicorp/terraform-github-actions/validate@<latest tag>"
  needs = "terraform init"
  args = ["-var", "'foo=bar'", "-var-file=foo"]
}
```
