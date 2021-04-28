resource "aws_subnet" "carla-pilot-pub-sn" {
    vpc_id                  = aws_vpc.carla-pilot-vpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone      = "us-east-1a"
}
resource "aws_subnet" "carla-pilot-prv01-sn" {
    vpc_id                  = aws_vpc.carla-pilot-vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone      = "us-east-1a"
}
resource "aws_subnet" "carla-pilot-prv02-sn" {
    vpc_id                  = aws_vpc.carla-pilot-vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone      = "us-east-1b"
}
