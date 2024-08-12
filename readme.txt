terraform plan -out=output -var-file="dev.tfvars"
terraform apply "output"

---

terraform destroy -var-file="dev.tfvars"

terraform show

---
### Get ami id of ecs optimized amazon-linux-2
Ref: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html

```
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --region us-east-2
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --query "Parameters[].Value" --output text
```

docker build -f webapp .
docker run --publish 80:3000 app

### Push to ECR
docker tag webapp:latest 395044016922.dkr.ecr.us-east-2.amazonaws.com/demo-farga:latest
