# AWS CloudFormation

CloudFormation components:
1. templates: JSON/YAML
2. parameters: key/value pairs
3. resources: ex: VPC, EC2, SubnetRouteTableAssocation
4. stacks: deployed form of the template


### Configure AWS Credentials for GitHub Actions
1. 2 IAM roles:
   1. auth to AWS cloud from the GitHub workflow
   2. deploy the AWS CloudFormation template

- [Automating AWS Infra with CFN and GH Actions](https://skundunotes.com/2024/05/24/automating-aws-infrastructure-with-cloudformation-and-github-actions-a-tutorial/)
  - https://github.com/kunduso/add-asg-lb-cloudformation
  - [Creating and managing an IAM OIDC identity provider (AWS CLI)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#manage-oidc-provider-console)
  - pre-req: [Securely integrate AWS Credentials with GitHub Actions using OpenID Connect](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/)



### create admin IAM user with cloudFormation

#### Step 1: Create the temporary bootstrap user

1. Create the temporary bootstrap user
```sh
aws iam create-user \
  --user-name cfn-bootstrap-temp
```
stdout:
```json
{
    "User": {
        "Path": "/",
        "UserName": "cfn-bootstrap-temp",
        "UserId": "AIDAS74TMBFG3QHAM6UNE",
        "Arn": "arn:aws:iam::205930629453:user/cfn-bootstrap-temp",
        "CreateDate": "2025-06-11T22:44:57+00:00"
    }
}
```

2. Create a tightly-scoped inline policy granting just the permissions needed:
```sh
cat > bootstrap-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCFNAndIAM",
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:DescribeStacks",
        "cloudformation:UpdateStack",
        "cloudformation:DeleteStack",
        "cloudformation:ListStacks",
        "iam:CreateUser",
        "iam:CreateGroup",
        "iam:CreatePolicy",
        "iam:CreateAccessKey",
        "iam:AttachUserPolicy",
        "iam:PutUserPolicy",
        "iam:PutAccountPasswordPolicy",
        "iam:DeleteUser",
        "iam:DeleteAccessKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
```

3. Attach that policy to the new user
```sh
aws iam put-user-policy \
  --user-name cfn-bootstrap-temp \
  --policy-name CFNBootstrapPolicy \
  --policy-document file://bootstrap-policy.json
```

4. Generate access keys for CLI usage
```sh
aws iam create-access-key \
  --user-name cfn-bootstrap-temp \
  > temp-creds.json
```
   1. cat temp-creds.json:
   ```json
   {
    "AccessKey": {
        "UserName": "cfn-bootstrap-temp",
        "AccessKeyId": "AKIAS74TMBFGV3W7J2UC",
        "Status": "Active",
        "SecretAccessKey": "<REDACTED>",
        "CreateDate": "2025-06-12T18:47:03+00:00"
      }
   }
   ```

^ `terraform output -json admin_secret_access_key` to get SecretAccessKey after creation

5. Extract and store these securely
BOOTSTRAP_AK=$(jq -r .AccessKey.AccessKeyId        temp-creds.json)
BOOTSTRAP_SK=$(jq -r .AccessKey.SecretAccessKey    temp-creds.json)

#### Step 2: Configure your CLI to use the bootstrap user

```sh
aws configure --profile bootstrap
# When prompted, paste in $BOOTSTRAP_AK and $BOOTSTRAP_SK,
# and set your default region (e.g. us-east-1) and output format (YAML, to filter with --query option)
```


# REFs

- https://github.com/Sceptre/sceptre