/*
Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. */

# Create the VPC
resource "aws_vpc" "blog_vpc" {
  cidr_block = local.blog_vpc_cidr
  tags = {
    Name = "blog-vpc"
  }
}

# Create IGW and attach to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.blog_vpc.id
  tags = {
    Name = "blog-igw"
  }
}

# Create the public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.blog_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = local.public_subnet_cidr[0]
  tags = {
    Name = "blog-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.blog_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = local.public_subnet_cidr[1]
  tags = {
    Name = "blog-public-subnet-2"
  }
}

# Create the private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.blog_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = local.private_subnet_cidr[0]
  tags = {
    Name = "blog-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.blog_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = local.private_subnet_cidr[1]
  tags = {
    Name = "blog-private-subnet-2"
  }
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_eip" "natgw_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "blog-natgw"
  }
}

# Route table creation
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "blog-public-route-table"
  }
}

resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "blog-private-route-table"
  }
}

# Route table Associations - Public Subnets
resource "aws_route_table_association" "public_subnet1_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public_subnet2_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

# Route table Association - Private Subnets
resource "aws_route_table_association" "private_subnet1_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_route_table_association" "private_subnet2_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_subnet_rt.id
}
