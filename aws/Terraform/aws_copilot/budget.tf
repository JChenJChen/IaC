# 2.1. Monthly Budget Alert (Terraform Equivalent)

provider "aws" {
  region = "us-east-1"
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = ["your-email@example.com"] # <-- Replace with your email
  }
}