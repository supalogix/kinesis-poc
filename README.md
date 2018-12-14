# How to use 

Make sure you have an AWS account

Configure your aws cli to use your AWS account with the following

```bash
aws configure
```

You need the following permissions enabled for your AWS user:
 - IAMFullAccess
 - AmazonS3FullAccess
 - CloudWatchFullAccess
 - AmazonKinesisFullAccess
 - AmazonKinesisFirehoseFullAccess

Go to the terraform folder

Initialize it with the following

```bash
terraform init
```

Modify the variables.tfvars file to suite your needs

Create the infrastructure on AWS with the following

```bash
terraform apply -var-file="variables.tfvars"
```

The javascript folder contains some sample code on how to publish to the kinesis delivery stream you setup in your terraform code

override the variables in index.js to suite your needs

you can test it with the following

```js
yarn
node index.js
```

You will not see any output if it worked. You have to go to the s3 bucket on your AWS console to see the logs. It takes a minute for the records to make it to s3 on the free tier.

If you see output on the terminal then something went wrong

destroy the infrastructure on AWS with the following

```bash
aws s3 rm s3://xxx-kinesis-bucket --recursive
terraform destroy -var-file="variables.tfvars"
```

make sure that the s3 bucket name is the same as the one in your variables.tfvars file

References:
 - https://medium.com/@clasense4/how-to-scaling-aws-kinesis-firehose-4ef4bea590e0
 - https://medium.com/@aoc/kinesis-firehose-to-redshift-pipeline-with-terraform-2261b5afd29d