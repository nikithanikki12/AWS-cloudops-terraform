resource "aws_vpc" "cloudops_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "cloudops-vpc"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.cloudops_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "cloudops-public-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudops_vpc.id

  tags = {
    Name = "cloudops-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "cloudops-public-route-table"
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_security_group" "ec2_sg" {
  name        = "cloudops-ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.cloudops_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["76.36.17.16/32"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cloudops_ec2" {
  ami                    = "ami-0152204c1a187337c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "cloudops-monitoring-ec2"
  }
}
resource "aws_sns_topic" "cpu_alert_topic" {
  name = "cloudops-cpu-alert-topic"
}
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cpu_alert_topic.arn
  protocol  = "email"
  endpoint  = "nikithashivakali03@gmail.com"
}
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name                = "cloudops-high-cpu-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This alarm triggers when EC2 CPU exceeds 80%"
  alarm_actions = [aws_sns_topic.cpu_alert_topic.arn]
  dimensions = {
        InstanceId = aws_instance.cloudops_ec2.id 
      }
}