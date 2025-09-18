import os
import boto3
import json

# Get the table name from an environment variable
TABLE_NAME = os.environ.get('TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)

def handler(event, context):
    """
    Handles API Gateway requests to fetch a dictionary definition.
    """
    # The 'term' is expected to be a path parameter
    term = event.get('pathParameters', {}).get('term')

    if not term:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Term not provided in path.'})
        }

    try:
        response = table.get_item(Key={'term': term})
        item = response.get('Item')

        if not item:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Term not found.'})
            }

        return {
            'statusCode': 200,
            # Allow CORS for frontend integration
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,GET'
            },
            'body': json.dumps(item)
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error.'})
        }