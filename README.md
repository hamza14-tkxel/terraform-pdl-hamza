# pdl-terraform
Terraform IaC configurations/scripts. By default it is configured to run on aws and use s3 as the backend provider. To run the backend locally update the backend as below
```
terraform {
  backend "local" {}
}
```

# Prerequisites
Terraform 14 or greater version should be installed on system

# To provision the enviroment 
Clone the repo

```
Run  terraform init
```
# Create Workspace for seperate state file

```
Run terraform workspace new abcd-dev
```
Above command will create a folder **terraform.tfstate.d** in current directory
# Workspace commands

```
terraform workspace list
terraform workspace select
terraform workspace delete

```
# Note
On terraform plan, apply and delete user need to provide the specfic runtime argument according to requirements

# To check the plan
```
Run terraform plan
```

# To initialize the Env
```
Run terraform apply
```

# To delete the Env
First select the workspace then 

```
Run terraform destroy
``` 

## Environment variables
* Change the backend s3 bucket and the key in the file `backend.hcl` and run the below init
```
terraform init -backend-config=backend.hcl -var-file="app.tfvars"  -reconfigure
```
reconfigure flag is only required if you are migrating the state to `s3`. If you are running it for the first time then remove the flag.

* Set the values in the file `app.tfvars` and run the init command
```
terraform init -var-file="app.tfvars"
```

* Run the plan as follows
```
terraform plan -var-file="app.tfvars"
```

* Run the apply as follows
```
terraform apply -var-file="app.tfvars"
```

* Run the destroy as follows
```
terraform destroy -var-file="app.tfvars"
```

## Logging
### TF_LOG
* Enables detailed logs to appear on stderr which is useful for debugging. For example:
```
export TF_LOG=trace
```
* To disable, either unset it, or set it to off. For example:
```
export TF_LOG=off
```
