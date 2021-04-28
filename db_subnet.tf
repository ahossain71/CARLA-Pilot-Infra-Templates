resource "aws_db_subnet_group" "carla-pilot-db_sngrp" {
    subnet_ids  = [aws_subnet.carla-pilot-prv01-sn.id, aws_subnet.carla-pilot-prv02-sn.id]
}