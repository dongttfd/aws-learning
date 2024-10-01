profile_config='localstack'
## function terminate instance with instance id

terminate_instance() {
  instance_id=$1
  aws ec2 --profile ${profile_config} stop-instances \
    --instance-ids $instance_id \
    --query "StoppingInstances[0].[InstanceId,CurrentState.Name]" \
    --output table
  aws ec2 --profile ${profile_config} terminate-instances \
    --instance-ids $instance_id \
    --query "TerminatingInstances[0].[InstanceId,CurrentState.Name]" \
    --output table
}

## input instance id
echo "Select function: Terminate Instance (1 - default) / Delete Security Group (2) / Delete Keypair (3) / Exit (0)"
read select_function

if [ $select_function -eq 1 ]; then
  echo "Terminate Instance"
  echo "Instance ID:"
  read instance_id
  terminate_instance $instance_id
  echo "Instance terminated"

  echo "Instances:"
  aws ec2 --profile ${profile_config} describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
    --output table
  exit 0
fi

if [ $select_function -eq 2 ]; then
  echo "Delete Security Group"
  echo "Security Group Name:"
  read security_group_name
  aws ec2 --profile ${profile_config} delete-security-group --group-name $security_group_name
  echo "Security Group deleted"
  exit 0
fi

if [ $select_function -eq 3 ]; then
  echo "Delete Keypair"
  echo "Keypair Name:"
  read key_name
  aws ec2 --profile ${profile_config} delete-key-pair --key-name $key_name
  echo "Keypair deleted"
  exit 0
fi

echo "Exit"
exit 0
