resource "aws_route_table" "carla-pilot-rtbl" {
    vpc_id = aws_vpc.carla-pilot-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.carla-pilot-igwy.id
    }
    tags = {
        Name = "carla-pilot-rtbl"
    }
}

resource "aws_route_table_association" "carla-pilot-route_table_association-a" {
    subnet_id      = aws_subnet.carla-pilot-prv01-sn.id
    route_table_id = aws_route_table.carla-pilot-rtbl.id
}
resource "aws_route_table_association" "carla-pilot-route_table_association-b" {
    subnet_id      = aws_subnet.carla-pilot-prv02-sn.id
    route_table_id = aws_route_table.carla-pilot-rtbl.id
}