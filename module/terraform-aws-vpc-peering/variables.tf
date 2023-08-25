variable "requester_vpc_id" {
  type        = string
  description = "The ID of the VPC belonging to the requester."
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
  default     = true
}

variable "accepter_vpc_id" {
  type        = string
  description = "The ID of the VPC belonging to the accepter."
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
  default     = true
}

variable "auto_accept" {
  type        = bool
  description = "Automatically accept the peering"
  default     = true
}

variable "tags" {
  type        = map(any)
  description = "The tags map to associate to the resources."
  default     = {}
}
