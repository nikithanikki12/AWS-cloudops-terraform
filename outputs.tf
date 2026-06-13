output "ec2_public_ip" {
    value = aws_instance.cloudops_ec2.public_ip
}
output "sns_topic_arn" {
    value = aws_sns_topic.cpu_alert_topic.arn 
}