output "topic_arn" {
  description = "ARN do tópico SNS"

  value = aws_sns_topic.alertas.arn
}

output "alarm_name" {
  description = "Nome do CloudWatch Alarm"

  value = aws_cloudwatch_metric_alarm.lambda_errors.alarm_name
}