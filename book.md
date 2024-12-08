Nếu bạn cần thực hành hoặc kiểm thử kiến trúc hệ thống nào đó với AWS thì Localstack cung cấp cho bạn AWS Cloud Stack  với đầy đủ các dịch vụ của AWS như: IAM, EC2, S3, Lamda, CloudWatch...

Dưới đây là các dịch vụ mà Localstack đã giả lập.

![](https://blog.localstack.cloud/images/blog/2023-11-09-introducing-localstack-desktop-application-for-local-cloud-development-testing/localstack-desktop-resource-browser.png)

### I. Cài đặt Localstack và các công cụ để thực hành

Trong [Document](https://docs.localstack.cloud/getting-started/installation/) đã hướng dẫn khá đầy đủ các bước cài đặt và cấu hình nhưng trong bài viết này mình sẽ chia sẻ cách cài trực tiếp trên Docker

##### 1. Các phần mềm cần cài đặt để sử dụng
- [Docker](https://www.docker.com/)
-  [awslocal CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal) hoặc [aws CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html): trong các ví dụ ở bài viết này tôi sẽ sử dụng `aws CLI`
- [Docker localstack Plugin](https://hub.docker.com/extensions/localstack/localstack-docker-desktop): Plugin dùng để xem trực quan các dịch vụ có trong Localstack mà bạn đang chạy, hoặc cấu hình một vài thông số môi trường cho Localstack, 
- [Localstack Dashboard](https://app.localstack.cloud/download): Nếu không muốn cài đặt [Docker localstack Plugin](https://hub.docker.com/extensions/localstack/localstack-docker-desktop) thì bạn có thể truy cập vào [Localstack Dashboard](https://app.localstack.cloud/download) để sử dụng.

##### 2. Cài đặt Localstack với docker
- Chạy `docker-compose up -d` với file `docker-compose.yaml` dưới đây

	```yaml
	version: "3.8"

	services:
		localstack:
			container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
			image: localstack/localstack
			ports:
				- "4566:4566"
				- "4510-4559:4510-4559"
				- "8080:8080"
				- "8000:8000"
				- "22:22"
			environment:
				# LocalStack configuration: https://docs.localstack.cloud/references/configuration/
				- DEBUG=${DEBUG:-0}
				- DEFAULT_REGION=us-east-1
				- DATA_DIR=/tmp/localstack/data
				- LAMBDA_EXECUTOR=docker
				- EAGER_SERVICE_LOADING=1
				- AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-LocalStackAccessKey}
				- AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-LocalStackSecretKey}
				- AWS_DEFAULT_REGION=${AWS_SECRET_ACCESS_KEY:-us-east-1}
			volumes:
				- "${LOCALSTACK_VOLUME_DIR:-./volume}:/var/lib/localstack"
				- "/var/run/docker.sock:/var/run/docker.sock"
	```

- Truy cập vào [Localstack Dashboard](https://app.localstack.cloud/inst/default/status) có thể thấy các dịch vụ AWS avaialbe trên Localstack của bạn, (Lưu ý: Không có gì là miễn phí, để dùng đẩy đủ dịch vụ vẫn phải đăng ký Pro Plan, nhưng số lượng dịch vụ miễn phí khá đủ để bạn có thể sử dụng).

### II. Cấu hình để sử dụng với `aws CLI`
#### 1. Cấu hình Localstack

Sửa biến môi trường của `docker-compose.yml`
```
AWS_ACCESS_KEY_ID=test-key-id
AWS_SECRET_ACCESS_KEY=test-access-key
AWS_DEFAULT_REGION=ap-southeast-1
```

#### 2. Cấu hình `aws CLI`

Chạy `aws configure --profile localstack` để cấu hình hoặc thực hiện các bước sau:

1. Thêm cấu hình cho `aws CLI` vào file `~/.aws/config`
	```
	[profile localstack]
	region=ap-southeast-1
	output=json
	endpoint_url=http://localhost:4566
	```

2.  Change Thêm credentials vào file `~/.aws/credentials`
```
[localstack]
aws_access_key_id=<your-key-id-at-env>
aws_secret_access_key=<your-access_key-at-env>
```

##### 3. Test S3 của Localstack với
- Thử chạy 2 câu lệnh: 
	```bash
	aws --profile localstack s3 mb s3://test-bucket
	aws --profile localstack s3 ls
	```
- Kết quả: bucket `test-bucket` đã được tạo
![](https://www2.online-converting.com/upload/api_e69c7c2292/result.jpg)

### III. Thử nghiệm với 1 project đơn giản
- Project đơn giản như sau: Tạo một `EC2 instance` với `Ubuntu` để chạy ứng dụng web bằng `apache2`

#### Tạo script
- Steps:
  - Tạo `Key-pair` dùng để ssh vào instance
  - Tạo `security group` và mở 2 cổng: 22, 80
  - Chuẩn bị script cài đặt `apache2` khi boot instance:
    ```bash
    #!/bin/bash
    apt update
    apt install -y apache2
    mv /var/www/html/index.html /var/www/html/index.html.bak
    echo "<html><body><h1>Hello, World!</h1></body></html>" > /var/www/html/index.html
    systemctl restart apache2

    ```
  - Tạo instance với script trên và `Key-pair`, `security group` đã tạo: Zone: `us-east-1a`, Instance type: `t2.micro`, Image: `ami-03fa85deedfcac80b` (danh sách image có thể tìm kiếm trên trang chủ của aws, các image sẵn có của aws đều có trong Localstack)
   

- Script tạo instance file `ec2.sh`
  ```bash
  # Configuration and Functions
  profile_config='localstack'
  availability_zone='ap-southeast-1a'
  key_name='ec2-keypair'
  security_group_name='default_security_group'
  image_id='ami-03fa85deedfcac80b'
  instance_type='t2.micro'

  ## function show ec2 instances
  show_ec2_instances() {
    echo "Instances:"
    aws ec2 --profile ${profile_config} describe-instances \
      --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,Placement.AvailabilityZone]' \
      --output table
  }

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

  ## create keypair
  aws ec2 --profile $profile_config delete-key-pair --key-name $key_name
  aws ec2 --profile $profile_config \
    create-key-pair \
    --key-name $key_name \
    --query 'KeyMaterial' \
    --output text | tee $key_name.pem

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
  ```

#### Kết quả chạy thử:
1. Môi trường Localstack
  - Chạy script `sh ec2.sh` kết quả instance đã được tạo và ở trạng thái running với ip `54.214.49.61`
  ![](https://www2.online-converting.com/upload/api_6a7db8c13e/result.jpg)
  - Trên [Localstack Dashboard](https://app.localstack.cloud/inst/default/resources/ec2), có thể thấy instance đã được tạo
  ![](https://www2.online-converting.com/upload/api_32b1bb63cb/result.jpg)

  - Thử ssh vào instance
    ```bash
      ssh -i ec2-keypair.pem ubuntu@54.214.49.61
    ```
  - `Time out ...`, điều này xảy ra vì Localstack chỉ xây dựng môi trường giả lập, không thực sự tạo ra một instance thực sự, nên không thể ssh vào instance được.
  ![](https://www2.online-converting.com/upload/api_a63d870517/result.jpg)

2. Môi trường AWS
  - Bây giờ hãy thêm 1 cấu hình cho `aws CLI` để sử dụng với môi trường AWS thực sự
    ```bash
    # ~/.aws/config
    [profile aws_production]
    region=ap-us-east-1
    output=json
    ```
    ```bash
    # ~/.aws/credentials
    [aws_production]
    aws_access_key_id=<your-key-id>
    aws_secret_access_key=<your-access-key>
    ```
  - Sửa file ``ec2.sh`` với cấu hình vừa tạo để chạy với môi trường AWS thực sự
    ```bash
    profile_config='aws_production'
    availability_zone='ap-southeast-1a' # zone của AWS
    ```
  - Chạy lại script `sh ec2.sh` kết quả instance đã được tạo và bạn có thể ssh vào được
  ![](https://www2.online-converting.com/upload/api_5266fd3d02/result.jpg)
  ![](https://www2.online-converting.com/upload/api_8b16200f1d/result.jpg)
  ![](https://www2.online-converting.com/upload/api_d98efa56f2/result.jpg)

### IV. Kết luận
#### Ưu điểm
- Localstack giúp bạn thực hành, kiểm thử các dịch vụ thông dụng của AWS mà:
  + Không cần trả phí
  + Không cần tạo tài khoản AWS
  + Không cần kết nối internet
  + Không cần lo lắng về việc làm thay đổi dữ liệu thật trên AWS
- Nếu bạn cần một công cụ để thử syntax của aws cli hoặc thực hành với các dịch vụ AWS thì Localstack là một lựa chọn tốt, 
- Bạn có thể xây dựng 1 project với sử dụng `aws CLI, Terraform, ...` và thử nghiệm trên Localstack trước khi thực hiện trên môi trường thực sự.

#### Nhược điểm
- Không thể giả lập hoàn toàn môi trường AWS, nên không thể thực hiện một số thao tác thực sự với dịch vụ đang chạy
- Không hỗ trợ tất cả các dịch vụ của AWS, nên không thể thực hành với tất cả các dịch vụ của AWS nhưng với các dịch vụ thông dụng thì Localstack hỗ trợ khá tốt để kiểm thử.
- Chỉ tao tác được với môi trường Localstack thông qua `aws CLI` không thể thực hiện qua giao diện web của AWS.

#### Documentation
- [Localstack](https://docs.localstack.cloud/overview/)
- [Localstack Github](https://github.com/localstack)
- [My Learning Note](https://github.com/dongttfd/aws-learning)
