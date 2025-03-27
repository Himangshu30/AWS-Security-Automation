#!/bin/bash
set -e

echo "=== Building Lambda Package ==="
cd lambda
rm -rf package && mkdir package
pip install -r requirements.txt -t package
cp security_lambda.py package/
cd package && zip -r ../security_lambda.zip . && cd ..

echo "=== Uploading Lambda Code ==="
BUCKET_NAME=$(cd ../terraform && terraform output -raw s3_bucket)
aws s3 cp security_lambda.zip s3://$BUCKET_NAME/lambda-zips/

echo "=== Deploying Infrastructure ==="
cd ../terraform
terraform init
terraform apply -auto-approve

echo "=== Enabling GuardDuty ==="
aws guardduty create-detector --enable

echo "=== Deployment Complete ==="
echo "Lambda ARN: $(terraform output -raw lambda_arn)"
echo "S3 Bucket: $(terraform output -raw s3_bucket)"
