resource "aws_vpc" "Jenkins_VPC" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Jenkins_VPC"
    }
}

resource "aws_subnet" "Jenkins_Subnets" {
    vpc_id     = aws_vpc.Jenkins_VPC.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Jenkins_Subnets"
    }
}

resource "aws_internet_gateway" "Jenkins_iGW" {
    vpc_id = aws_vpc.Jenkins_VPC.id
    tags = {
        Name = "Jenkins_iGW"
    }
}

resource "aws_route_table" "Jenkins_Public_RT" {
    vpc_id = aws_vpc.Jenkins_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Jenkins_iGW.id
    }
    tags = {
        Name = "Jenkins_Public_RT"
    }
}

resource "aws_route_table_association" "Jenkins_Public_Assoctiate" {
    subnet_id      = aws_subnet.Jenkins_Subnets.id
    route_table_id = aws_route_table.Jenkins_Public_RT.id
}

resource "aws_security_group" "Jenkins_SG" {
  vpc_id = aws_vpc.Jenkins_VPC.id
  
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "Jenkins_SG"
  }
}
