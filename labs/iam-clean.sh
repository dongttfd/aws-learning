source ./common/config.sh
source ./helpers/iam.helper.sh

## input instance id
while true; do
  echo "Select IAM function:"
  echo "1: Delete IAM Group"
  echo "2: Delete IAM User"
  echo "3: Delete IAM Access Key"
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
    echo "Delete IAM Access Key:"
    show_iam_users
    echo "Enter user: "
    read user_name
    show_iam_access_keys ${user_name}
    echo "Enter Access Key ID: "
    read access_key_id
    delete_iam_access_key $access_key_id
    echo "Access Key deleted."
    show_iam_access_keys ${user_name}
    ;;
  *)
    echo "Exit"
    exit 0
    ;;
  esac
done
