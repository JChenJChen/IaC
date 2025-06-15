https://spacelift.io/blog/terraform-tutorial

1. install terraform via tfenv
   1. go to https://github.com/tfutils/tfenv
   2. git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
   3. echo 'export PATH=""$HOME/.tfenv/bin:$PATH""' >> ~/.bash_profile
      1. (gnome terminal = bash by default)
   4. source ~/.bash_profile
   5. tfenv install [latest version]
   6. tfenv use 1.10.5

2. install AWS CLI
   1. create terraform IAM user
      1. username = 'terraform-user'
      2. tag = 'terraform'
      3. create access key
3. install `jq`

terraform provider
| Provider | Version Constraint | terraform init (no lock file) | terraform init (lock file) |
|----------|--------------------|-------------------------------|----------------------------|
| aws      | >= 4.5.0           | Latest version (e.g. 5.55.0)  | Lock file version (4.5.0)  |


> Following Quick Start Steps generated in [GitHub CoPilot chat](https://github.com/copilot/c/771fae9c-b705-4744-a1f7-02e8ff0231bb)

4. 