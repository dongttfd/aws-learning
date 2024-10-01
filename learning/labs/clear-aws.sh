source ./config.sh

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
echo "Select function:"
echo "1: Terminate Instance"
echo "2: Delete Security Group"
echo "3: Delete Keypair"
echo "4: Delete AMI"
echo "0: Exit"
read selected_function

case $selected_function in
1)
  aws ec2 --profile ${profile_config} describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
    --output table
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
  ;;
2)
  aws ec2 --profile ${profile_config} describe-security-groups \
    --query 'SecurityGroups[*].[GroupName]' \
    --output table
  echo "Delete Security Group"
  echo "Security Group Name:"
  read security_group_name
  aws ec2 --profile ${profile_config} delete-security-group --group-name $security_group_name
  echo "Security Group deleted"
  exit 0
  ;;

3)
  aws ec2 --profile ${profile_config} describe-key-pairs \
    --query 'KeyPairs[*].[KeyName]' \
    --output table
  echo "Delete Keypair"
  echo "Keypair Name:"
  read key_name
  aws ec2 --profile ${profile_config} delete-key-pair --key-name $key_name
  echo "Keypair deleted"
  exit 0
  ;;
4)
  aws ec2 --profile ${profile_config} describe-images \
    --filters "Name=name,Values=${image_name_manual}" \
    --query 'Images[*].[ImageId,Name,CreationDate]' \
    --output table
  echo "Delete AMI"
  echo "AMI Name:"
  read image_name
  image_id=$(aws ec2 --profile ${profile_config} describe-images \
    --filters "Name=name,Values=${image_name}" \
    --query 'Images[0].[ImageId]' \
    --output text)
  aws ec2 --profile ${profile_config} deregister-image --image-id $image_id
  echo "AMI deleted"
  exit 0
  ;;
0)
  echo "Exit"
  exit 0
  ;;
*)
  echo "Exit"
  exit 0
  ;;
esac
