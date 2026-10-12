resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.monitoring.id
  cidr_block = "10.20.0.0/24"
  map_public_ip_on_launch= "true"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "monitoring-public-subnet"
  }

}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.monitoring.id
  cidr_block = "10.20.1.0/24"
  availability_zone = "eu-west-1a"

}
