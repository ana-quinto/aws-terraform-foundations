import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")

def lambda_handler(event, context):

    tabela = dynamodb.Table(
        os.environ["TABLE_NAME"]
    )

    response = tabela.scan()

    return {
        "statusCode": 200,
        "body": json.dumps(response["Items"])
    }