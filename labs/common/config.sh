LOCALSTACK='localstack'
LOCALSTACK_ENDPOINT='http://localhost:4566'

profile_config=${LOCALSTACK}
availability_zone='us-east-1a'
region_config='us-east-1'

# profile_config='dongtt561'
# profile_config='dongtt'
# availability_zone='ap-southeast-1a'
# region_config='ap-southeast-1'

key_name='ec2-keypair'
security_group_name='default_security_group'
image_id='ami-03fa85deedfcac80b'
instance_type='t2.micro'

image_name_manual='ami-from-instance-manual'

### Custom profile awcli
iam_custome_group_name='DeveloperGroup'
iam_custome_user_name='dongtt'
