source ./common/config.sh

# Show IAM Groups
show_iam_groups() {
  echo "IAM Groups:"
  aws iam --profile ${profile_config} list-groups \
    --query="Groups[*].[GroupId,GroupName,Arn,Path]" \
    --output table
}

# Show IAM Policy Detail of Group
show_iam_policy_detail_of_group() {
  aws iam --profile ${profile_config} list-attached-group-policies \
    --group-name $iam_custome_group_name \
    --query="AttachedPolicies[*].[PolicyName,PolicyArn]" \
    --output table
}

# Delete IAM Group
delete_iam_group() {
  local group_name=$1
  aws iam --profile ${profile_config} delete-group \
    --group-name ${group_name}
}

# Show IAM Users
show_iam_users() {
  echo "IAM Users:"
  aws iam --profile ${profile_config} list-users \
    --query="Users[*].[UserId,UserName,Arn,Path]" \
    --output table
}

# Delete IAM User
delete_iam_user() {
  local user_name=$1
  # Remove all MFAs devices
  aws iam --profile ${profile_config} list-mfa-devices \
    --user-name ${user_name} \
    --query="MFADevices[*].[SerialNumber]" \
    --output text | while read serial_number; do
    aws iam --profile ${profile_config} deactivate-mfa-device \
      --user-name ${user_name} \
      --serial-number ${serial_number}
  done

  # Delete user
  aws iam --profile ${profile_config} delete-user \
    --user-name ${user_name}
}

# Show IAM Policies
show_manual_iam_policies() {
  echo "Manual IAM Policies:"
  aws iam --profile ${profile_config} list-policies \
    --scope Local \
    --query 'Policies[*].{Name:PolicyName, Arn:Arn}' \
    --output table
}

# Delete IAM Policy
delete_manual_iam_policy() {
  local policy_arn=$1
  aws iam --profile ${profile_config} delete-policy \
    --policy-arn ${policy_arn}
}

# Show IAM Access Keys
show_iam_access_keys() {
  local user_name=$1
  aws iam --profile ${profile_config} list-access-keys \
    --user-name ${user_name} \
    --query="AccessKeyMetadata[*].[AccessKeyId,UserName,Status]" \
    --output table
}

# Delete IAM Access Key
delete_iam_access_key() {
  local access_key_id=$1
  local user_name=$1
  aws iam --profile ${profile_config} delete-access-key \
    --user-name user_name \
    --access-key-id ${access_key_id}
}

# AWS config with new user of localstack
config_iam_aws_cli_profile() {
  local access_key=$1
  local secret_key=$2
  local region=$3
  local profile_name=$4

  if [[ -z $access_key || -z $secret_key || -z $region || -z $profile_name ]]; then
    echo "Please provide all required parameters: access_key, secret_key, region, profile_name"
    exit 1
  fi

  aws configure set aws_access_key_id $access_key --profile $profile_name
  aws configure set aws_secret_access_key $secret_key --profile $profile_name
  aws configure set region $region --profile $profile_name
  aws configure set output json --profile $profile_name

  # enpoint url for localstack
  if [[ $profile_config == $LOCALSTACK ]]; then
    aws configure set endpoint_url $LOCALSTACK_ENDPOINT --profile $profile_name
  fi
}

#AWS get configuration
get_aws_configuration() {
  local profile_name=$1
  echo "AWS Configuration:"
  echo "profile: ${profile_name}"
  echo "access_key: $(aws configure get aws_access_key_id --profile ${profile_name})"
  echo "secret_key: $(aws configure get secret_key --profile ${profile_name})"
  echo "region: $(aws configure get region --profile ${profile_name})"
  echo "endpoint_url: $(aws configure get endpoint_url --profile ${profile_name})"
}

# Attach MFA policy to group
attach_mfa_policy_to_group() {
  local policy_arn=$1
  local group_name=$2
  aws iam --profile $profile_config attach-group-policy \
    --group-name $group_name \
    --policy-arn $policy_arn

  echo "Group $group_name policies:"
  aws iam --profile $profile_config list-attached-group-policies \
    --group-name $group_name \
    --query="AttachedPolicies[*].[PolicyName,PolicyArn]" \
    --output table
}

# Detach MFA policy from group
detach_mfa_policy_from_group() {
  local policy_arn=$1
  local group_name=$2
  aws iam --profile $profile_config detach-group-policy \
    --group-name $group_name \
    --policy-arn $policy_arn

  echo "Group $group_name policies:"
  aws iam --profile $profile_config list-attached-group-policies \
    --group-name $group_name \
    --query="AttachedPolicies[*].[PolicyName,PolicyArn]" \
    --output table
}

# Show policies of group
show_policies_of_group() {
  local group_name=$1
  aws iam --profile $profile_config list-attached-group-policies \
    --group-name $group_name \
    --query="AttachedPolicies[*].[PolicyName,PolicyArn]" \
    --output table
}

# Show IAM Users from Group
show_iam_users_from_group() {
  local group_name=$1
  aws iam --profile $profile_config get-group \
    --group-name $group_name \
    --query="Users[*].[UserId,UserName,Arn,Path]" \
    --output table
}

# Remove User from Group
remove_user_from_group() {
  local user_name=$1
  local group_name=$2
  aws iam --profile $profile_config remove-user-from-group \
    --user-name $user_name \
    --group-name $group_name
}
