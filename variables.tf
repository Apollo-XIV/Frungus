# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

 variable "subnet_id_1" {
  type = string
  default = "subnet-0e102e794b95ed793"
 }
 
 variable "subnet_id_2" {
  type = string
  default = "subnet-07041ac0579e22eee"
 }

 variable "my_role_arn" {
   description = "ARN of the IAM role to use"
   type = string
   default = "arn:aws:iam::360122086346:role/AmazonEKSClusterPolicy"
 }