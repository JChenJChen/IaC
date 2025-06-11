## Setup Steps

1. install terraform via tfenv:
```sh
https://github.com/tfutils/tfenv
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
(gnome terminal = bash by default)
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
tfenv install 1.10.5 (latest)
tfenv use 1.10.5
```
2. install gcloud
3. install optional components: 
   1. google-cloud-cli-terraform-validator
   2. kubectl
   3. [kubectx (& kubens)](https://stackoverflow.com/questions/69070582/how-can-i-install-kubectx-on-ubuntu-linux-20-04)
4. gcloud init &rarr; https://cloud.google.com/sdk/auth_success
5. gcloud auth application-default login
6. **manually** create TF remote state GCS bucket 
7. create backend.tf, re- terraform init to copy existing/local tfstate to remote GCS bucket
8. install [tflint](https://github.com/terraform-linters/tflint)
9. 

### TODO's

- setup GH workflow CI/CD to auto-apply TF changes in GH repo
  - setup IAM for TF runner with workload identity federation
- setup google.cloud secretmanager & add secrets, get secrets in code
- learn/figure out bootstrapping?  
  - and multi-repo setup?
- implement tflint in GH CI/CD?
- create & setup k8s cluster
  - other necessary things? networking? LB? firewall rules? IAM?
 -
### Misc. Notes

- Best to **manually** create master project and remote state bucket, instead of with TF. [[Ref](https://stackoverflow.com/a/69720292)] 
- terraform import google_project.existing test-terraform-gke-20250605
- naming character limits:
  - GCP:
    - Project IDs: 30 characters
    - resource names (ex: GCS buckets, GCE instances, Cloud Fn's): 63 characters
      - GCE names must comply with RFC1035, 1-63 chars &&...
        - must match the regular expression [a-z]([-a-z0-9]*[a-z0-9]), i.e.:
        - first character must be a lowercase letter
        - all following characters must be a dash, lowercase letter, or digit, except...
        - last character, which cannot be a dash
        - GCP recommends 4-30 chars for GCE instance names
      - Bucket names with dots: 222 characters, but each component <= 63 characters
     

### REFs

- /code/DevOps/DevOps/DevOps/01-bootstrap/*
- /code/DevOps/DevOps/DevOps/.github/workflows/*-workflow.yaml
- /code/DevOps/infrastructure/content/terraform/*