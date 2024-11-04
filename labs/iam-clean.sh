source ./common/config.sh
source ./helpers/iam.helper.sh

## input instance id
while true; do
  echo "Select IAM function:"
  echo "1: Delete IAM Group"
  echo "2: Delete IAM User"
  echo "3: Delete Policy"
  echo "4: Delete IAM Access Key"
  echo "5: Attach Policy to Group"
  echo "6: Detach Policy to Group"
  echo "7: Remove User from Group"
  echo "0: Exit"
  read selected_function

  case $selected_function in
  1)
    show_iam_groups
    echo "Delete IAM Group"
    echo "Group name:"
    read group_name
    delete_iam_group $group_name
    echo "Group deleted."
    show_iam_groups
    ;;
  2)
    show_iam_users
    echo "Delete IAM User"
    echo "User name:"
    read user_name
    delete_iam_user $user_name
    echo "User deleted."
    show_iam_users
    ;;
  3)
    show_manual_iam_policies
    echo "Delete Policy"
    echo "Policy arn:"
    read policy_arn
    delete_manual_iam_policy $policy_arn
    echo "Policy deleted."
    show_manual_iam_policies
    ;;
  4)
    echo "Delete IAM Access Key:"
    show_iam_users
    echo "Enter user: "
    read user_name
    show_iam_access_keys $user_name
    echo "Enter Access Key ID: "
    read access_key_id
    delete_iam_access_key $access_key_id $user_name
    echo "Access Key deleted."
    show_iam_access_keys $user_name
    ;;
  5)
    echo "Attach policy to Group:"
    show_iam_groups
    echo "Enter group: "
    read group_name
    show_manual_iam_policies
    echo "Enter policy arn: "
    read policy_arn
    attach_mfa_policy_to_group $policy_arn $group_name
    ;;
  6)
    echo "Detach policy to Group:"
    show_iam_groups
    echo "Enter group: "
    read group_name
    show_policies_of_group $group_name
    echo "Enter policy arn: "
    read policy_arn
    detach_mfa_policy_from_group $policy_arn $group_name
    ;;
  7)
    echo "Remove user from Group:"
    show_iam_groups
    echo "Enter group: "
    read group_name
    show_iam_users_from_group $group_name
    echo "Enter user: "
    read user_name
    remove_user_from_group $user_name $group_name
    ;;
  *)
    echo "Exit"
    exit 0
    ;;
  esac
done
