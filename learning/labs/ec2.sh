key_name='ec2-lab'
security_group_name='default_security_group'
profile_config='localstack'

# clean all keypair, security group has name existed
aws ec2 --profile ${profile_config} delete-key-pair --key-name $key_name
aws ec2 --profile ${profile_config} delete-security-group --group-name $security_group_name

# Create Key pair
aws ec2 --profile ${profile_config} \
  create-key-pair \
  --key-name ec2-lab \
  --query 'KeyMaterial' \
  --output text | tee ec2-lab.pem

# Remove key pair
# aws ec2 --profile localstack delete-key-pair --key-name ec2-lab

# Create Security Group
aws ec2 --profile ${profile_config} \
  create-security-group \
  --group-name $security_group_name \
  --description "Default Security Group"

# Show Security Group name created
# aws ec2 --profile localstack \
#   describe-security-groups \
#   --group-names 'default_security_group'

# Show Security Group id created

security_group_id=$(aws ec2 --profile ${profile_config} \
  describe-security-groups \
  --group-names $security_group_name \
  --query 'SecurityGroups[0].GroupId' \
  --output text)
echo "Security Group ID: $security_group_id"

# Add port 80 and 22 to this security with group id created
aws ec2 --profile ${profile_config} \
  authorize-security-group-ingress \
  --profile ${profile_config} \
  --group-id ${security_group_id} \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0 
aws ec2 --profile ${profile_config} \
  authorize-security-group-ingress \
  --profile ${profile_config} \
  --group-id ${security_group_id} \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

echo "Security configuration done:"
aws ec2 --profile ${profile_config} \
  describe-security-groups \
  --group-names $security_group_name

