# Amazon Elastic Compute Cloud (EC2)

## Công cụ thực hành:
- Giả lập aws: [localstack](https://www.localstack.cloud/)
- Client tool: [aws CLI](https://docs.aws.amazon.com/cli/)
- [EC2 CLI document](https://docs.aws.amazon.com/cli/latest/reference/ec2/)
- Alias `aws <service> --profile localstack` => `awslocal <service>`, change `.zshrc`:
```
awslocal() {
    local command=$1
    shift
    aws "$command" --profile localstack "$@"
}
```

## Đặc trưng
- Đa dạng cấu hình: RAM / CPU / GPU / Network (VPC), EBS volume (ổ cứng), Snapshot (Ghost) ...
- Dễ triển khai
- Khả năng mở rộng gần như không giới hạn
- Linh hoạt trong việc trả phí

## Layer
- EC2 chạy trên Hypervisor (trình ảo hóa) của AWS
- Người dùng chỉ có thể can thiệp ở tầng OS trở lên, AWS không can thiệp từ tầng OS trở lên của EC2 instance
- EC2 instance hoạt động độc lập

## Khái niệm cơ bản
- Amazon Machine Image (AMI): Giống như 1 file Ghost / ISO, EC2 được khởi động lên từ file này
- EBS Volume: Ổ cứng ảo được cấp phát bởi Amazon, chỉ được đọc khi được gắn vào instance
- Snapshot: Ảnh chụp của Volume tại 1 thời điểm
- Instance: Một máy chủ ảo được cấp phát tài nguyên CPU, RAM, GPU ... tùy dòng instance

## Life Cycle
- Khi ở trạng thái terminated không thể phục hồi
- Các hành động tương tác với instance: Launch, Reboot, Stop, Start, Terminate
- Các hành động ảnh hưởng đến instance: Attach /Detach Volume, IP, Security Group, IAM Role, Create Snapshot, AMI
- Instance-store volume: sẽ mất dữ liệu khi stop, không có trạng thái stop, là một lựa chọn khi người dùng muốn tốc độ IOPS (ouput in per second) cực cao. Chỉ hỗ trợ một số loại instance nhất định
## Security Group: 
- Giới hạn truy cập, bản chất là network
- Rule là stateful, request đến sẽ tự động nhận được response, không cần định nghĩa tường minh cho traffic đi ra
- Inbound rule: Request đi vào instance
- Outbound rule: Request từ instance đi ra, default mở full
- Một instance có thể allow nhiều Security Group

## Các bước khởi chạy EC2 instance bằng aws CLI
#### Chuẩn bị Keypair
- Create keypair: 
```
aws ec2 create-key-pair \
  --profile localstack \
  --key-name <your-key-name> \
  --query 'KeyMaterial' \
  --output text | tee key.pem
```
- Sử dụng key có sẵn
```
aws ec2 import-key-pair --profile localstack --key-name <your-key-name> --public-key-material file://<path-your-public-key>
```

- Xem danh sách keypair
```
aws ec2 --profile localstack describe-key-pairs
```
- Xóa keypair
```
aws ec2 --profile localstack delete-key-pair --key-name <your-key-name>
```

#### Cấu hình Security Group
- Thêm cổng 8000 Inbound rule
```
aws ec2 authorize-security-group-ingress \
  --profile localstack \
  --group-id default \
  --protocol tcp \
  --port 8000 \
  --cidr 0.0.0.0/0
```

- Thêm cổng 22 Outbound rule
```
aws ec2 authorize-security-group-ingress \
  --profile localstack \
  --group-id default \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

- Xem lại cấu hình Security Group
```
aws ec2 --profile localstack describe-security-groups
```

### Chuẩn bị images/instance

- Xem danh sách images
```
aws ec2 --profile localstack describe-images
```
- Xem danh sách images dưới dạng table
```
aws ec2 --profile localstack describe-images --query 'Images[*].[ImageId,Name]' --output table
```

- Xem danh sách instance types:
```
aws ec2 --profile localstack describe-instance-types
```

- Xem danh sách instance types dưới dạng table
```
aws ec2 --profile localstack describe-instance-types --query 'InstanceTypes[*].[InstanceType,VCpuInfo.DefaultVCpus,MemoryInfo.SizeInMiB]' --output table
```

### Step 3: Khởi chạy instance
```
aws ec2 --profile localstack run-instances \
    --image-id <image-id> \
    --count 1 \
    --instance-type t3.nano \
    --key-name <your-key-name> \
    --security-group-ids <security-group-id>
    --user-data file://./user_script.sh
```
### Show instance running and
```
aws ec2 --profile localstack describe-instances
```
- Display with table format
```
aws ec2 --profile localstack describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' --output table
```

- SSH vào instance
```
ssh -i key.pem ec2-user@<public-ip>
```

### Stop and terminate instance
```
aws ec2 --profile localstack stop-instances --instance-ids <instance-id>
aws ec2 --profile localstack terminate-instances --instance-ids <instance-id>
```

### Remove instance
```
aws ec2 --profile localstack delete-security-group --group-id <group-id>
aws ec2 --profile localstack delete-key-pair --key-name <key-name>
```

- fix: Docker Desktop on macOS does not expose the bridge network to the host system
```
docker run -d -p 8000:8000 --network="host" --name=localstack localstack/localstack
```

- connect to localstack ec2 instance
```
aws --endpoint-url=http://localhost:4566 ec2 describe-instances
```