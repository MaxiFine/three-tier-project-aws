import boto3
import json
import os

# Initialize Route53 client
route53 = boto3.client('route53')

# Environment variables provided via Terraform
HOSTED_ZONE_ID    = os.environ['HOSTED_ZONE_ID']
RECORD_NAME       = os.environ['RECORD_NAME']
SECONDARY_TARGET  = os.environ['SECONDARY_TARGET']
SECONDARY_ZONE_ID = os.environ['SECONDARY_ZONE_ID']

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    
    # Create the change batch to update the record
    response = route53.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID,
        ChangeBatch={
            'Comment': 'Failover DNS update triggered by CloudWatch alarm',
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': RECORD_NAME,
                        'Type': 'A',
                        'AliasTarget': {
                            'HostedZoneId': SECONDARY_ZONE_ID,
                            'DNSName': SECONDARY_TARGET,
                            'EvaluateTargetHealth': False
                        }
                    }
                }
            ]
        }
    )
    print("Change response:", response)
    return {
        'statusCode': 200,
        'body': json.dumps('DNS failover update executed successfully')
    }
