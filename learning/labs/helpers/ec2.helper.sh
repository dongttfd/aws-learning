source ./common/config.sh

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

## function show ec2 instances
show_ec2_instances() {
  echo "Instances:"
  aws ec2 --profile ${profile_config} describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,Placement.AvailabilityZone]' \
    --output table
}

## function show ec2 security groups
show_ec2_security_groups() {
  echo "Security Groups:"
  aws ec2 --profile ${profile_config} describe-security-groups \
    --query "SecurityGroups[*].[GroupName]" \
    --output table
}

## function show ec2 key pairs
show_ec2_key_pairs() {
  echo "Key Pairs:"
  aws ec2 --profile ${profile_config} describe-key-pairs \
    --query 'KeyPairs[*].[KeyName]' \
    --output table
}

## function show ec2 volumes
show_ec2_volumes() {
  echo "Volumes:"
  aws ec2 --profile ${profile_config} describe-volumes \
    --query 'Volumes[*].[VolumeId,Size,VolumeType,State,AvailabilityZone,Attachments[0].InstanceId,Attachments[0].State]' \
    --output table
}
