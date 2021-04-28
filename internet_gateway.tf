resource "aws_internet_gateway" "carla-pilot-igwy" {
    vpc_id = aws_vpc.carla-pilot-vpc.id
    tags = {
         Name = "carla-pilot-igwy"
    }
}