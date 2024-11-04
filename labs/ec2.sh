source ./common/config.sh
source ./helpers/ec2.helper.sh

## create keypair
aws ec2 --profile $profile_config delete-key-pair --key-name $key_name
aws ec2 --profile $profile_config \
  create-key-pair \
  --key-name $key_name \
  --query 'KeyMaterial' \
  --output text | tee $key_name.pem

# Create Security Group
aws ec2 --profile $profile_config delete-security-group --group-name $security_group_name
aws ec2 --profile $profile_config \
  create-security-group \
  --group-name $security_group_name \
  --description "Default Security Group" \
  --output table

security_group_id=$(aws ec2 --profile $profile_config \
  describe-security-groups \
  --group-names $security_group_name \
  --query 'SecurityGroups[0].GroupId' \
  --output text)

# add port 22 and 80 to security group
aws ec2 --profile $profile_config \
  authorize-security-group-ingress \
  --profile $profile_config \
  --group-id $security_group_id \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0 \
  --query 'SecurityGroupRules[0].[GroupId,IpProtocol,ToPort]' \
  --output table
aws ec2 --profile $profile_config \
  authorize-security-group-ingress \
  --profile $profile_config \
  --group-id $security_group_id \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0 \
  --query 'SecurityGroupRules[0].[GroupId,IpProtocol,ToPort]' \
  --output table

echo "Security configuration done:"
aws ec2 --profile $profile_config \
  describe-security-groups \
  --group-names $security_group_name \
  --query "SecurityGroups[*].[GroupName, IpPermissions[*].[FromPort, ToPort, IpRanges[*].CidrIp]]" \
  --output table

# create EC2 instance
aws ec2 --profile $profile_config run-instances \
  --image-id $image_id \
  --count 1 \
  --instance-type $instance_type \
  --key-name $key_name \
  --security-group-ids $security_group_id \
  --placement "AvailabilityZone=$availability_zone" \
  --query 'Instances[0].[ImageId,InstanceType,State.Name,PublicIpAddress,SecurityGroups[0].GroupName,Placement.AvailabilityZone]' \
  --output table \
  --user-data file://./scripts/install.sh

show_ec2_instances
