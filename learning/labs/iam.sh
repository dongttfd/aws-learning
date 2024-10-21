# IAM Lab
source ./common/config.sh
source ./helpers/iam.helper.sh

# Create Developer Group
aws iam --profile ${profile_config} create-group --group-name ${iam_custome_group_name}

# Attach AdministratorAccess Policy to Developer Group
aws iam --profile ${profile_config} attach-group-policy \
  --group-name DeveloperGroup \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Create User
aws iam --profile ${profile_config} create-user --user-name ${iam_custome_user_name}

# Add User to Developer Group
aws iam --profile ${profile_config} add-user-to-group \
  --user-name ${iam_custome_user_name} \
  --group-name ${iam_custome_group_name}

# Create Access Key for User
output=$(aws iam --profile ${profile_config} create-access-key --user-name ${iam_custome_user_name})

echo "Access Key Created:"
echo ${output}

# Get UserName
UserName=$(echo "$output" | grep '"UserName"' | awk -F'"' '{print $4}')
# Get AccessKeyId
AccessKeyId=$(echo "$output" | grep '"AccessKeyId"' | awk -F'"' '{print $4}')
# Get SecretAccessKey
SecretAccessKey=$(echo "$output" | grep '"SecretAccessKey"' | awk -F'"' '{print $4}')

config_iam_aws_cli_profile ${AccessKeyId} ${SecretAccessKey} ${region_config} ${iam_custome_user_name}
show_iam_groups
show_iam_policy_detail_of_group ${iam_custome_group_name}
show_iam_users
show_iam_access_keys ${iam_custome_user_name}

echo "IAM configuration done."
get_aws_configuration ${iam_custome_user_name}