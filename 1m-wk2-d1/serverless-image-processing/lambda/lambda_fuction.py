import boto3
from PIL import Image
import io

s3 = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']
    destination_bucket = "image-processed-bucket"
    
    # Download image from source bucket
    response = s3.get_object(Bucket=source_bucket, Key=source_key)
    image = Image.open(io.BytesIO(response['Body'].read()))
    
    # Process image (resize)
    resized_image = image.resize((128, 128))
    buffer = io.BytesIO()
    resized_image.save(buffer, format="JPEG")
    buffer.seek(0)
    
    # Upload processed image to destination bucket
    destination_key = f"processed-{source_key}"
    s3.put_object(Bucket=destination_bucket, Key=destination_key, Body=buffer)
    
    return {
        'statusCode': 200,
        'body': f"Image processed and stored at {destination_bucket}/{destination_key}"
    }
