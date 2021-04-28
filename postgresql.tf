#resource "aws_db_instance" "mysql" {
#    identifier                = "mysql"
#    allocated_storage         = 5
#    backup_retention_period   = 2
#    backup_window             = "01:00-01:30"
#    maintenance_window        = "sun:03:00-sun:03:30"
#    multi_az                  = true
#    engine                    = "mysql"
#    engine_version            = "5.7"
#    instance_class            = "db.t2.micro"
#    name                      = "worker_db"
#    username                  = "worker"
#    password                  = "worker"
#    port                      = "3306"
#    db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.id
#    vpc_security_group_ids    = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
#    skip_final_snapshot       = true
#    final_snapshot_identifier = "worker-final"
#    publicly_accessible       = true
#}

resource "aws_db_instance" "carla-pilot-postgresql" {
  allocated_storage        = 5 # gigabytes
  db_subnet_group_name     = aws_db_subnet_group.carla-pilot-db_sngrp.id
  engine                   = "postgres"
  engine_version           = "9.6.9"
  identifier               = "carla-pilot-postgresql"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "carlapilotDB"
  #parameter_group_name    = "mydbparamgroup1" # if you have tuned it
 #password                 = "${trimspace(file("${path.module}/secrets/mydb1-password.txt"))}"
  password                 = "carlapass"
  username                 = "carlaadmin"
  port                     = 5432
  publicly_accessible      = false
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
 #vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
  vpc_security_group_ids=[aws_security_group.carla-pilot-rds-sg.id]
  skip_final_snapshot      = true
  backup_retention_period  = 0
  apply_immediately        = true
}