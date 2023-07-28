#Terraform Code
###############################


provider "aws" {
  region  = "us-east-1"
  profile = "abhioct18"
}

resource "aws_vpc" "TF-VPC-1" {
  cidr_block           = "10.99.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
#  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "TF-VPC-1"
  }
}
resource "aws_subnet" "TF-Sub-1a" {
  vpc_id                  = aws_vpc.TF-VPC-1.id
  cidr_block              = "10.99.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "TF-Sub-1a"
  }
}

resource "aws_subnet" "TF-Sub-1b" {
  vpc_id                  = aws_vpc.TF-VPC-1.id
  cidr_block              = "10.99.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "TF-Sub-1b"
  }
}


resource "aws_security_group" "TF-SG-1" {
  name   = "TF-SG-1"
  vpc_id = aws_vpc.TF-VPC-1.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #  lifecycle {
  #    create_before_destroy = true
  #  }
}

resource "aws_internet_gateway" "TF-IGW-1" {
  vpc_id = aws_vpc.TF-VPC-1.id
  tags = {
    Name = "TF-IGW-1"
  }
}

resource "aws_route_table" "TF-rtb-1" {
  vpc_id = aws_vpc.TF-VPC-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TF-IGW-1.id
  }

  tags = {
    Name = "TF-rtb-1"
  }
}

resource "aws_route_table_association" "TF-associate-sub-1a" {
  subnet_id      = aws_subnet.TF-Sub-1a.id
  route_table_id = aws_route_table.TF-rtb-1.id
}

resource "aws_instance" "TF-EC2-1" {
  ami                         = "ami-0f34c5ae932e6f0e4"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TF-Sub-1a.id
  associate_public_ip_address = true
  key_name                    = "TF-Key-1"


  vpc_security_group_ids = [
    "${aws_security_group.TF-SG-1.id}"
  ]
  #  root_block_device {
  #    delete_on_termination = true
  #    iops = 150
  #    volume_size = 50
  #    volume_type = "gp2"
  #  }
  tags = {
    Name = "TF-EC2-USE1a-1"
    #    Environment = "DEV"
    #    OS = "UBUNTU"
    #    Managed = "IAC"
  }
  #
  #  depends_on = [ aws_security_group.project-iac-sg ]
}
#
#
#output "ec2instance" {
#  value = aws_instance.project-iac.public_ip
#}
