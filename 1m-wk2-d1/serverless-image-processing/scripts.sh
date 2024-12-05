#/bin/bash

# Create the buckets where the images would be stored
aws s3api create-bucket --bucket image-upload-bucket --region us-east-1
aws s3api create-bucket --bucket image-processed-bucket --region us-east-1

# Automate the deletion of objects from the bucket using a lifecycle policy
aws s3api put-bucket-lifecycle-configuration \
  --bucket image-upload-bucket \
  --lifecycle-configuration file://lifecycle.json

# Package application and create lambda function.
zip lambda_function.zip lambda/lambda_function.py
aws lambda create-function \
  --function-name ProcessImage \
  --runtime python3.13 \
  --role arn:aws:iam::YOUR_ROLE_ARN \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda_function.zip

# Set up S3 to trigger lambda on file upload
aws s3api put-bucket-notification-configuration \
  --bucket image-upload-bucket \
  --notification-configuration file://notification.json

# Manage dependencies with layers
# Create a dependency layer for Pillow (Image processing library)
mkdir python
pip install Pillow -t python/
zip -r9 pillow_layer.zip python
# Publish layer
aws lambda publish-layer-version \
  --layer-name PillowLayer \
  --zip-file fileb://pillow_layer.zip \
  --compatible-runtimes python3.13
# Attach layer to lambda function.
aws lambda update-function-configuration \
  --function-name ProcessImage \
  --layers arn:aws:lambda:<region>:<account-id>:layer:PillowLayer:<version>

