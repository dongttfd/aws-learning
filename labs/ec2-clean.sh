source ./common/config.sh
source ./helpers/ec2.helper.sh

## input instance id
while true; do
  echo "Select function:"
  echo "1: Terminate Instance"
  echo "2: Delete Security Group"
  echo "3: Delete Keypair"
  echo "4: Delete AMI"
  echo "0: Exit"
  read selected_function

  case $selected_function in
  1)
    show_ec2_instances
    echo "Terminate Instance"
    echo "Instance ID:"
    read instance_id
    terminate_instance $instance_id
    echo "Instance terminated"
    show_ec2_instances
    ;;
  2)
    show_ec2_security_groups
    echo "Delete Security Group"
    echo "Security Group Name:"
    read security_group_name
    aws ec2 --profile ${profile_config} delete-security-group --group-name $security_group_name
    echo "Security Group deleted"
    show_ec2_security_groups
    ;;

  3)
    show_ec2_key_pairs
    echo "Delete Keypair"
    echo "Keypair Name:"
    read key_name
    aws ec2 --profile ${profile_config} delete-key-pair --key-name $key_name
    echo "Keypair deleted"
    show_ec2_key_pairs
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
    ;;
  *)
    echo "Exit"
    exit 0
    ;;
  esac
done
