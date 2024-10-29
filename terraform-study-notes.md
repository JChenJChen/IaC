# Terraform Study Notes

variable "name_label" {
    type = value
    description = "string"
    default = value
    sensitive = true | false
    ...
}

referencing collection values:
var.<name_label>.<key_name> or   var.<name_label>["key_name"]

![order of evaluation](image.png)

#### Interacting with Terraform State Data

- terraform refresh (deprecated)
- terraform plan/apply -refresh-only
- terraform taint ADDR
- terraform plan/apply -replace="ADDR"
- terraform state mv OLD_ADDR NEW_ADDR (deprecated)
- moved {
    from = OLD_ADDR
    to = NEW_ADDR
}
- terraform state rm ADDR
- terraform state list
- terraform state show ADDR
- terraform state pull
- terraform state push PATH

- terraform init -backend-config="bucket=xyz"
- terraform init -backend-config="backend-settings.txt"


Terraform Automation Env Vars
- TF_IN_AUTOMATION = TRUE
- TF_LOG = "INFO"
- TF_LOG_PROVIDER = "ERROR"
- TF_LOG_PATH = "FILEPATH"
- TF_INPUT = FALSE
- TF_VAR_name = "VALUE"
- TF_CLI_ARGS = "COMMAND FLAGS"

#### GitHub Actions Workflow
- in a job: `if: (success() || failure())` --> job runs regardless whether previous job succeeds or fails

#### Common Approaches to multiple environments
- terraform OS workspaces
- directories & TF files
- branches or release tags
- separate repositories
