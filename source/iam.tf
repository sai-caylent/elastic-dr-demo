# ###############################################################################
# # AWS EDR Agent Installation Role/Instance profile
# ###############################################################################
module "iam_assumable_role_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  role_name = "drs_agent_installation_role"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    # "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryEc2InstancePolicy",
    "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"
  ]
}
# ###############################################################################
# # Allow AWS EDR to save CF tempate in S3 Bucket
# ###############################################################################
module "edr_network_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  trusted_role_services = [
    "drs.amazonaws.com"
  ]

  create_role             = true
  create_instance_profile = false
  role_requires_mfa       = false

  role_name = "edr_network_role"
  custom_role_policy_arns = [
    aws_iam_policy.s3_access_policy.arn
  ]

}
# ###############################################################################
# # Attach this role to instance to run assessment on CloudEndure upgrade eligibily
# ###############################################################################
module "edr_assessment_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  trusted_role_services = [
    "drs.amazonaws.com"
  ]

  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  role_name = "cloud_endure_assessment_role"
  custom_role_policy_arns = [
    aws_iam_policy.cloud_endure.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]

}
# ###############################################################################
# # IAM user to upgrade CloudEndure Agent
# ###############################################################################
module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "CEDR_DRS_User"
  force_destroy = true

  create_iam_user_login_profile = false
  create_iam_access_key         = false
  policy_arns                   = [aws_iam_policy.example_policy.arn, "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"]
}
