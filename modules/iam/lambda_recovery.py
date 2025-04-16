# import boto3
# import os
# import subprocess

#### def lambda_handler(event, context):
#     region = os.environ['REGION']
#     repo_url = os.environ['REPO_URL']

#     subprocess.run(["git", "clone", repo_url, "/tmp/repo"])
#     cf_client = boto3.client('cloudformation', region_name=region)
#     with open('/tmp/repo/stack-template.yaml', 'r') as f:
#         template = f.read()

#     cf_client.create_stack(
#         StackName='SecondaryRegionStack',
#         TemplateBody=template,
#         Capabilities=['CAPABILITY_IAM']
#     )
#     return {"status": "Secondary region provisioning started"}



############## 
# USING CODE BUILDER
import boto3
import os

def lambda_handler(event, context):
    codebuild = boto3.client('codebuild')
    
    response = codebuild.start_build(
        projectName="TerraformDRProject",
        environmentVariablesOverride=[
            {
                'name': 'TF_REGION',
                'value': os.environ['REGION'],
                'type': 'PLAINTEXT'
            },
            {
                'name': 'TF_ACTION',
                'value': 'apply',
                'type': 'PLAINTEXT'
            }
        ]
    )
    return {"status": "Build started", "build_id": response['build']['id']}

