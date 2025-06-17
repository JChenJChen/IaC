# Terraform

(Henceforth, TF short for Terraform.)

TF can be run in a local or cloud environment, the TF state respectively will reside locally in the project dir, or remotely in cloud storage (i.e. AWS s3 or GCS bucket) 

## Contents

- Subdirs for TF files each cloud provider:
  1. AWS
  2. GCP
- `/.github/workflows/`: workflow that automatically deploys infra changes. Consists of GitHub actions that run TF cmds (init, plan, apply) to diff and then apply changes.
    - To Do (in progress): scan for directories with TF file changes and only run TF cmds on them.
- Reference notes on Terraform cmds.
