# variable "requester_region" {
#   type        = string
#   description = "Requester AWS region"
#   default = "us-east-2"
# }

# variable "requester_vpc_id" {
#   type        = string
#   description = "Requester VPC ID filter"
# }

# variable "requester_allow_remote_vpc_dns_resolution" {
#   type        = bool
#   description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
#   default     = true
# }


# variable "accepter_region" {
#   type        = string
#   description = "Accepter AWS region"
# }

# variable "accepter_vpc_id" {
#   type        = string
#   description = "Accepter VPC ID filter"
# }

# variable "accepter_allow_remote_vpc_dns_resolution" {
#   type        = bool
#   description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
#   default     = true
# }

variable "tags" {
  type        = map(any)
  description = "The tags map to associate to the resources."
  default     = {}
}
