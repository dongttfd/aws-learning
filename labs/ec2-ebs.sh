source ./common/config.sh
source ./helpers/ec2.helper.sh

# Create EBS volume
create_ebs_volume() {
  echo "Create EBS volume:"
  aws ec2 --profile $profile_config create-volume \
    --availability-zone $availability_zone \
    --size 1 \
    --volume-type gp2 \
    --query 'VolumeId' \
    --output table
}

# Attach EBS volume to instance
attach_ebs_volume() {
  echo "Attach EBS volume to instance"
  echo "Volume ID:"
  read volume_id
  echo "Instance ID:"
  read instance_id
  aws ec2 --profile $profile_config attach-volume \
    --volume-id $volume_id \
    --instance-id $instance_id \
    --device /dev/sdf \
    --query 'State' \
    --output table
}
# Detact EBS volume to instance
detach_ebs_volume() {
  echo "Detacth Volume"
  echo "Volume ID:"
  read volume_id
  aws ec2 --profile $profile_config detach-volume --volume-id $volume_id
  echo "Volume detacthed"
}
# Delete EBS volume
delete_ebs_volume() {
  echo "Delete EBS volume"
  echo "Volume ID:"
  read volume_id
  aws ec2 --profile $profile_config delete-volume --volume-id $volume_id
  echo "Volume deleted"
}

# Create EBS volume
# Enter 1 to create EBS volume, 2 to attach EBS volume to instance, 0 to exit
while true; do
  echo "Select EBS function:"
  echo "1: Create EBS volume"
  echo "2: Attach EBS volume to instance"
  echo "3: Detact EBS volume to instance"
  echo "4: Delete Volume"
  echo "0: Exit"
  read selected_ebs_function

  case $selected_ebs_function in
  1)
    create_ebs_volume
    show_ec2_volumes
    ;;
  2)
    show_ec2_instances
    show_ec2_volumes
    attach_ebs_volume
    show_ec2_volumes
    ;;
  3)
    show_ec2_volumes
    detach_ebs_volume
    show_ec2_volumes
    ;;
  4)
    show_ec2_volumes
    delete_ebs_volume
    show_ec2_volumes
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
done
