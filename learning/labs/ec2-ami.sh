source ./common/config.sh
source ./helpers/ec2.helper.sh

show_ec2_instances

# Create AMI from running instance
echo "Create AMI from running instance"
echo "Instance ID:"
read instance_id
aws ec2 --profile ${profile_config} create-image \
  --instance-id $instance_id \
  --name ${image_name_manual} \
  --description "AMI from instance" \
  --no-reboot \
  --query "ImageId" \
  --output table

echo "AMI created:"
aws ec2 --profile ${profile_config} describe-images \
  --filters "Name=name,Values=${image_name_manual}" \
  --query 'Images[*].[ImageId,Name,CreationDate]' \
  --output table

echo "Do you want run new instance from AMI ${image_name_manual}?"
echo "1: Yes"
echo "0: No"
read run_instance
case $run_instance in
1)
  aws ec2 --profile ${profile_config} describe-images \
    --filters "Name=name,Values=${image_name_manual}" \
    --query 'Images[*].[ImageId]' \
    --output table
  echo "Image ID:"
  read image_id
  aws ec2 --profile ${profile_config} run-instances \
    --image-id $image_id \
    --count 1 \
    --instance-type ${instance_type} \
    --key-name ${key_name} \
    --security-group-ids ${security_group_id} \
    --query 'Instances[0].[ImageId,InstanceType,State.Name,PublicIpAddress,SecurityGroups[0].GroupName]' \
    --output table
  show_ec2_instances
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
