# example-fargate

## Apply.

```
terraform plan -out=output -var-file="dev.tfvars"
terraform apply "output"
```

## How to build image 
```
docker build -t wnote-with-multistage-dockerfile --platform linux/amd64 -f Dockerfile .
(add --platform linux/amd64 for build image with M1 chipset)

docker run -i -p 3000:3000 --name wnote-server wnote-with-multistage-dockerfile

docker tag wnote-with-multistage-dockerfile:latest {account_id}.dkr.ecr.us-east-2.amazonaws.com/demo-farga:latest
```


## Destroy.

```
terraform destroy -var-file="dev.tfvars"
```

## Check status.

```
terraform show
```

---
### Get ami id of ecs optimized amazon-linux-2
Ref: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html

```
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --region us-east-2
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --query "Parameters[].Value" --output text
```

## Build docker

### Build and push to ECR

```
cd app/
docker build -f webapp .

docker tag webapp:latest {account_id}.dkr.ecr.us-east-2.amazonaws.com/{repo_name}:latest
```

### Run test local

```
docker run --publish 3000:3000 app
```

