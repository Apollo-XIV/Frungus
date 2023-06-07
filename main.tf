# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}


resource "aws_eks_cluster" "cluster" {
    name = "my-cluster"
    role_arn = "arn:aws:iam::360122086346:role/LabRole"
    vpc_config {
      subnet_ids = [var.subnet_id_1, var.subnet_id_2]
    }
}

resource "aws_eks_node_group" "node_group" {
    cluster_name = aws_eks_cluster.cluster.name
    node_group_name = "node_group"
    node_role_arn = "arn:aws:iam::360122086346:role/LabRole"
    subnet_ids = [var.subnet_id_1, var.subnet_id_2]
    instance_types = ["t3.medium"]

    scaling_config {
      desired_size = 2
      max_size = 3
      min_size = 1
    }

}