provider "aws" {
  region = var.region
  profile = vamshi4b2
}

data "aws_availability_zone" "AZ" {}

#create VPC
resource "aws_vpc" "TF-VPC" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "TF-Subnet" {
  count = var.number_of_subnets
  vpc_id = aws_vpc.TF-VPC.id
  cidr_block = cidr
}