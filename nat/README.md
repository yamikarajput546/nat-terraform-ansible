
## TF_VAR

```
export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""
export TF_VAR_aws_region=""
```

## using profile

```
aws configure --profile yamika
```
## make changes in provider.tf
```
provider "aws" {
    profile = "yamika"
    region = var.aws_region
}
```

## for instance2 

create a key-pair with .pem extensionand pass the local path to private_key_path

## Initialize the terraform working directory

```
terraform init
```

## apply the configuration file

```
terraform apply
```

## destroying the provisioned infra

```
terraform destroy
```
