import boto3

def start_instances(instance_ids):
    ec2 = boto3.client('ec2')
    ec2.start_instances(InstanceIds=instance_ids)
    print(f'Started EC2 instances: {instance_ids}')

def stop_instances(instance_ids):
    ec2 = boto3.client('ec2')
    ec2.stop_instances(InstanceIds=instance_ids)
    print(f'Stopped EC2 instances: {instance_ids}')

def lambda_handler(event, context):
    ec2 = boto3.client("ec2")

    # Get all EC2 instances
    instances = ec2.describe_instances()["Reservations"]
    instance_ids = [instance["Instances"][0]["InstanceId"] for instance in instances]

    if event['action'] == 'start':
        # Turn on instances
        ec2.start_instances(InstanceIds=instance_ids)
    elif event['action'] == 'stop':
        # Turn off instances
        ec2.stop_instances(InstanceIds=instance_ids)
