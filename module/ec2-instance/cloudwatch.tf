# data "aws_region" "current" {}

# resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
#   count = var.cpu_alarm_threshold > 0 ? 1 : 0

#   alarm_name                = "${var.name}-cpu-utilization"
#   alarm_description         = "EC2 High CPU Utilization"
#   alarm_actions             = var.alarm_actions
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   statistic                 = "Average"
#   period                    = "60" #seconds
#   evaluation_periods        = var.cpu_alarm_evaluation_periods
#   threshold                 = "90"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   insufficient_data_actions = []
#   dimensions = {
#     InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#   }
# }

# # Threshold should be set based on the baseline EC2 network performance as detailed here: https://cloudonaut.io/ec2-network-performance-cheat-sheet/
# resource "aws_cloudwatch_metric_alarm" "network_utilization_alarm" {
#   count = var.network_alarm_threshold > 0 ? 1 : 0

#   alarm_name                = "${var.name}_network_utilization"
#   alarm_description         = "EC2 High Network Utilization"
#   alarm_actions             = var.alarm_actions
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = var.network_alarm_evaluation_periods
#   threshold                 = var.network_alarm_threshold
#   datapoints_to_alarm       = var.network_alarm_evaluation_periods
#   insufficient_data_actions = []

#   metric_query {
#     id          = "network_total"
#     label       = "NetworkUtilization"
#     expression  = "((network_in+network_out)/60/1000/1000/1000*8)" #/0.90*100"
#     return_data = true
#   }

#   metric_query {
#     id = "network_in"
#     metric {
#       namespace   = "AWS/EC2"
#       metric_name = "NetworkIn"
#       stat        = "Sum"
#       period      = 60
#       dimensions = {
#         InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#       }
#     }
#     return_data = false
#   }

#   metric_query {
#     id = "network_out"
#     metric {
#       namespace   = "AWS/EC2"
#       metric_name = "NetworkOut"
#       stat        = "Sum"
#       period      = 60
#       dimensions = {
#         InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#       }
#     }
#     return_data = false
#   }
# }

# # Requires CloudWatch Agent to be installed and configured on the host machine
# resource "aws_cloudwatch_metric_alarm" "ec2_memory" {
#   count = var.disk_space_alarm_threshold > 0 ? 1 : 0

#   alarm_name                = "${var.name}-memory-utilization"
#   alarm_description         = "EC2 High Memory Utilization"
#   alarm_actions             = var.alarm_actions
#   metric_name               = "Memory % Committed Bytes In Use"
#   namespace                 = "CWAgent"
#   statistic                 = "Average"
#   period                    = "60" #seconds
#   evaluation_periods        = var.memory_alarm_evaluation_periods
#   threshold                 = "90"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   insufficient_data_actions = []
#   dimensions = {
#     InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#   }
# }

# # Requires CloudWatch Agent to be installed and configured on the host machine
# resource "aws_cloudwatch_metric_alarm" "ec2_disk_space" {
#   count = var.disk_space_alarm_threshold > 0 ? 1 : 0

#   alarm_name                = "${var.name}-logical-disk-space-low"
#   alarm_description         = "EC2 Low Disk Space"
#   alarm_actions             = var.alarm_actions
#   metric_name               = "LogicalDisk % Free Space"
#   namespace                 = "CWAgent"
#   statistic                 = "Average"
#   period                    = "60" #seconds
#   evaluation_periods        = var.memory_alarm_evaluation_periods
#   threshold                 = "10"
#   comparison_operator       = "LessThanOrEqualToThreshold"
#   insufficient_data_actions = []
#   dimensions = {
#     InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "ec2_system_failure" {
#   alarm_name          = "${var.name}-system-check-fail"
#   alarm_description   = "System check has failed for ${var.name}"
#   alarm_actions       = var.restart_on_system_failure ? concat(var.alarm_actions, ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]) : var.alarm_actions
#   metric_name         = "StatusCheckFailed_System"
#   namespace           = "AWS/EC2"
#   statistic           = "Maximum"
#   period              = "300"
#   evaluation_periods  = "3"
#   datapoints_to_alarm = "3"
#   threshold           = "1"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   dimensions = {
#     InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#   }
# }


# resource "aws_cloudwatch_metric_alarm" "ec2_instance_failure" {
#   alarm_name          = "${var.name}_instance_check_fail"
#   alarm_description   = "Instance check has failed for ${var.name}"
#   alarm_actions       = var.restart_on_instance_failure ? concat(var.alarm_actions, ["arn:aws:automate:${data.aws_region.current.name}:ec2:reboot"]) : var.alarm_actions
#   metric_name         = "StatusCheckFailed_Instance"
#   namespace           = "AWS/EC2"
#   statistic           = "Maximum"
#   period              = "300"
#   evaluation_periods  = "3"
#   datapoints_to_alarm = "3"
#   threshold           = "1"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   dimensions = {
#     InstanceId = var.ignore_ami_changes ? aws_instance.ignore_ami[0].id : aws_instance.this[0].id
#   }
# }
