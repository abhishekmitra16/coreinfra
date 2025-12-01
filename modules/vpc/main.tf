# data "aws_vpc" "existing_vpc" {

#   tags = {
#     "Name" = var.vpc_name
#   }

# }





# data "aws_security_group" "alb_sg" {
#   filter {
#     name   = "tag:Name"
#     values = [var.alb_sg_name]
#   }

#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
# }

# data "aws_subnets" "public" {

#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
# }

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# PUBLIC SUBNETS

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_4" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1d"

  map_public_ip_on_launch = true
}


# PRIVATE SUBNETS

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1c"
}


# IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# ROUTE TABLE

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }

}


# PUBLIC ROUTE TABLE ASSOCIATIONS

resource "aws_route_table_association" "public_subnet_1_assoc" {

  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {

  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_3_assoc" {

  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_4_assoc" {

  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}


# PRIVATE ROUTE TABLE ASSOCIATIONS

resource "aws_route_table_association" "private_subnet_1_assoc" {

  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_subnet_2_assoc" {

  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_subnet_3_assoc" {

  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private.id

}




# ECS SG

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    # cidr_blocks = []
    description = "Allow inbound traffic on application port from loadbalancer SG"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS inbound traffic from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    description = "Allow HTTP inbound traffic from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }

}

# PRIVATE HOSTED ZONE

resource "aws_route53_zone" "private" {
  name = "${var.project_name}.internal"

  vpc {
    vpc_id = aws_vpc.main_vpc.id
  }

  tags = {
    Name = "${var.project_name}-private-zone"
  }
}