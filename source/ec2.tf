# ###############################################################################
# # EC2 Module
# ###############################################################################

module "ec2_linux" {
  source = "../module/ec2-instance"
  name   = "source-linux"

  ami                         = local.ec2_linux
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.private_subnets, 1)
  vpc_security_group_ids      = [module.security-group["ec2_linux"].security_group_id]
  associate_public_ip_address = false

  iam_instance_profile = module.iam_assumable_role_admin.iam_instance_profile_id

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true
  key_name                    = "edmentum-ohio"
  enable_volume_tags          = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2"
      volume_size = 20
      tags = {
        Name = "my-root-block"
      }
    },
  ]

}

# module "ec2_windows_private" {
#   source = "../module/ec2-instance"

#   name = "source-windows"

#   ami                         = local.ec2_windows
#   instance_type               = "t2.medium"
#   subnet_id                   = element(module.vpc.public_subnets, 1)
#   vpc_security_group_ids      = [module.security-group["ec2_windows"].security_group_id]
#   associate_public_ip_address = true

#   iam_instance_profile = module.iam_assumable_role_admin.iam_instance_profile_id


#   key_name           = "edmentum-ohio"
#   enable_volume_tags = false
#   root_block_device = [
#     {
#       device_name = "C:"
#       encrypted   = true
#       volume_type = "gp2"
#       volume_size = 30
#       tags = {
#         Name = "my-root-block"
#       }
#     },
#   ]

# }
