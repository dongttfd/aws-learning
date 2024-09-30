profile_config='localstack'
## function terminate instance with instance id

terminate_instance() {
  instance_id=$1
  aws ec2 --profile localstack stop-instances \
    --instance-ids $instance_id \
    --query "StoppingInstances[0].[InstanceId,CurrentState.Name]" \
    --output table
  aws ec2 --profile localstack terminate-instances \
    --instance-ids $instance_id \
    --query "TerminatingInstances[0].[InstanceId,CurrentState.Name]" \
    --output table
}

## input instance id
echo "Enter instance id to terminate: "
read instance_id
terminate_instance $instance_id

echo "Instances:"
aws ec2 --profile localstack describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
  --output table