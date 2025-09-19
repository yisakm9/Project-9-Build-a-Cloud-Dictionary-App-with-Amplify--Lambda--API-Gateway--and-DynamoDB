import os
import boto3
import json

TABLE_NAME = os.environ.get('TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)

# Define the CORS headers in one place to reuse them
CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*', # Allows any origin
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'OPTIONS,GET'
}

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    term = event.get('pathParameters', {}).get('term')

    if not term:
        return {
            'statusCode': 400,
            'headers': CORS_HEADERS, # Add headers
            'body': json.dumps({'error': 'Term not provided in path.'})
        }

    try:
        response = table.get_item(Key={'term': term})
        item = response.get('Item')

        if not item:
            return {
                'statusCode': 404,
                'headers': CORS_HEADERS, # Add headers
                'body': json.dumps({'error': 'Term not found.'})
            }

        # This is the successful case
        return {
            'statusCode': 200,
            'headers': CORS_HEADERS, # Add headers
            'body': json.dumps(item)
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'headers': CORS_HEADERS, # Add headers
            'body': json.dumps({'error': 'Internal server error.'})
        }