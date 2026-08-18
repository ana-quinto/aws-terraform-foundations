# Tópico SNS que receberá os alertas
resource "aws_sns_topic" "alertas" {
  name = "shopcloud-alertas"
}

# Envia notificações para o e-mail informado
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alertas.arn

  protocol = "email"
  endpoint = var.email_alerta
}

# Monitora erros da Lambda do Lab 03
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "lambda-errors-${var.lambda_name}"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1

  metric_name = "Errors"
  namespace   = "AWS/Lambda"

  statistic = "Sum"
  period    = 60

  threshold = var.threshold

  dimensions = {
    FunctionName = var.lambda_name
  }

  # Quando entrar em ALARM envia mensagem para o SNS
  alarm_actions = [
    aws_sns_topic.alertas.arn
  ]

  alarm_description = "Dispara quando a Lambda registra erros"
}