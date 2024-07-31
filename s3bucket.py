import boto3
import uuid
import re

def find_existing_bucket(bucket_prefix):
    s3 = boto3.client('s3')
    buckets = s3.list_buckets()

    for bucket in buckets['Buckets']:
        if bucket['Name'].startswith(bucket_prefix):
            return bucket['Name']

    return None

def find_existing_table(table_prefix):
    dynamodb = boto3.client('dynamodb')
    tables = dynamodb.list_tables()

    for table_name in tables['TableNames']:
        if table_name.startswith(table_prefix):
            return table_name

    return None

bucket_prefix = "my-s3-bucket"
s3_bucket_name = find_existing_bucket(bucket_prefix)

if s3_bucket_name is None:
    s3_bucket_name = f"{bucket_prefix}-{str(uuid.uuid4())[:8]}"

table_prefix = "my-dynamodb-table"
dynamodb_table_name = find_existing_table(table_prefix)

if dynamodb_table_name is None:
    dynamodb_table_name = f"{table_prefix}-{str(uuid.uuid4())[:8]}"

with open("cloudformation/s3.yaml", "r") as file:
    content = file.read()

content = re.sub(r"(?<=Default: )default-name", s3_bucket_name, content)
content = re.sub(r"(?<=Default: )default-lock", dynamodb_table_name, content)

with open("cloudformation/s3.yaml", "w") as file:
    file.write(content)

with open("terraform/staging/backend.tf", "r") as file:
    content = file.read()

content = re.sub(r'(bucket\s*=\s*")\S+(")', r'\1' + s3_bucket_name + r'\2', content)
content = re.sub(r'(dynamodb_table\s*=\s*")\S+(")', r'\1' + dynamodb_table_name + r'\2', content)

with open("terraform/staging/backend.tf", "w") as file:
    file.write(content)
