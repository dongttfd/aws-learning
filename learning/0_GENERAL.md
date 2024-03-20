# Giới thiệu
- Cloud Computing là một mô hình cung cấp các dịch vụ, ứng dụng logic, mạng, lưu trữ ... thông qua mạng internet
- Mô hình cung cấp cho người dùng sự linh hoạt, khả năng mở rộng dễ dàng, do đó giúp họ tiết kiệm chi phí và tối đa hiệu quả hoạt động.

## Cloud Providers
- On premise: Sở hữu phần cứng và tự cài đặt vận hành hạ tầng
- Public cloud: Sử dụng tài nguyên qua internet và trả tiền cho người cung cấp dịch vụ
- Private cloud: Xây dựng cloud cho tổ chức, doanh nghiệp và các tài nguyên chỉ available cho một số người sử dụng
- Hybrid cloud: tổ chức sử dụng Public Cloud kết hợp với Private cloud để sử dụng cho các công việc đặc thù
- Multiple Cloud: Sử dụng nhiều hơn một Cloud Provider

## Các loại dịch vụ
- Infrastructure as a Serivce (IaaS): Cơ sở hạ tầng như dịch vụ, khách hàng thuê các tài nguyên: server, storage... tự quản lý
- Platform as a Service (PaaS): Nền tảng dịch vụ, cung cấp môi trường thực thi ứng dụng
- Software as a service (SaaS): Phần mềm dưới dạng dịch vụ, người dùng chỉ cần truy cập vào và sử dụng phần mềm.

## AWS services
- AWS được coi như một IaaS có một số dịch vụ đặc thù không phải là Iaas như:
  - EC2, S3, VPC được coi như IaaS
  - Elastic, BeanStalk, Lambda được coi như PaaS
  - SES, WorkMail được coi như SaaS

## Các dịch vụ Amazon Web Services
#### Computing & Container
Các dịch vụ tạo ra máy chủ ảo hỗ trợ deploy source hoặc docker image
- Amazon Elastic Compute Cloud(EC2)
- AWS Elastic Beanstalk
- AWS Lambda
- Amazon EC2 Auto Scaling
- Amazon Elastic Container Registry (ECR): Chứa các docker Image
- Amazon Elastic Container Service (ECS): Chạy các container
- Amazon Elastic Kubernetes Service (EKS)

#### Storage
- Amazon Elastic Block Store (EBS): Cung cấp ổ cứng dưới dạng block
- Amazon Simple Storage Service (S3): Lưu trữ object
- Amazon Elastic File System (EFS): Lưu trữ internal file system
- AWS Backup
- Storage Gateway ...

#### Networking
- Amazon Virtual Private Cloud (VPC)
- Amazon Cloud front: Mạng phân phối global CDN
- AWS Cloud Map: Mạng phân phối CDN nội bộ
- Amazon Route 53: Quản lý DNS, tên miền
- Elastic Load Balancing: Cân bằng tải

#### Database
- Amazon Aurora: Hỗ trợ một số engine SQL
- Amazon ElastiCache: Data Caching
- Amazon DynamoDB: NoSQL độc quyền của Amazon
- Amazon Relational Database Service (RDS): Dữ liệu quan hệ
- Amazon DocumentDB: Hỗ trợ mongoDB
- Amazon MemoryDB for Redis 

#### Security & Identity
- AWS Identity ad Access Management (IAM): Quản lý: user, role, permission, account
- AWS Key Management Service: Quản lý mã hóa
- AWS Secrets Manager: Quản lý username / password
- Amazon Cognito: Dịch vụ quản lý authenticator / author của ứng dụng
- AWS WAF: Tường lửa
- AWS Certificate Manager (ACM): Quản lý Certificate, SSL

#### Management & Governance
- AWS Config: Quản lý cấu hình,
- AWS Management Console: Màn hình Console tương tác của người dùng
- AWS CloudTrail: Quản lý truy vết
- AWS Control Tower: Quản lý nhiều account trong tổ chức
- AWS System Manager: Quản lý thao tác Update, Patching
- AWS Trust Advisor: Các lời khuyên về Security
- AWS Organization: Quản lý tổ chức
- AWS CloudFormation: Deploy hệ thống từ template
- AWS Well-Architected Tool: Thiết kế hệ thống đạt chuẩn
- AWS Resource Explorer: Quản lý tài nguyên sử dụng

#### Monitoring
- Amazon Cloud Watch: Monitoring hệ thống
- AWS CloudTrail: Quản lý truy vết

#### Messaging, Application Integration
- Amazon Simple Mail Service (SES): Dịch vụ mail service
- Amazon Simple Notification Service (SNS): Notification
- Amazon Simple Queue Service (SQS): Message Queue
- Amazon EventBridge: Event automation
- Amazon API Gateway: Expose api cho người dùng cuối

#### Deploy & Automation
- AWS Cloud9: Cung cấp môi trường phát triển cho developer mà không cần local
- AWS Code Build: Build code (CICD)
- AWS Code Commit: Commit code (CICD)
- AWS Code Deploy: Deploy code (CICD)
- AWS Code Pipeline (CICD)
- AWS X-Ray: Giám sát
- AWS Cloud Development Kit (CDK): CDK cho developer
- AWS CloudShell: Command line trên web

#### Migration
- AWS Database Migration Service (DMS): Migrate database
- AWS Server Migration Service (SMS): Migrate server

#### Bigdata & Data analytic
- Amazon Redshift: tổng hợp báo cáo từ dữ liệu lớn
- Amazon QuickSight: Biểu đồ

#### AI & Machine Learning
- AWS Polly: Chuyển đổi text - giọng nói
- AWS Rekognition: Nhận diện hình ảnh
- AWS SageMaker: Train model
- AWS Transate: Dịch thuật
- Amazon Code Guru: Coding