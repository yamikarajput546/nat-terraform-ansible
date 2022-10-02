# mysql security group
resource "aws_security_group" "sg_mysql" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.vpc.id

   ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# mysql ec2 instance
resource "aws_instance" "instance-mysql" {
  depends_on = [
    aws_security_group.sg_mysql,
    aws_nat_gateway.nat_gateway,
    aws_route_table_association.associate_routetable_to_private_subnet,
  ]
  ami = "ami-062df10d14676e201"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.test.key_name

  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  subnet_id = aws_subnet.private_subnet.id
  user_data = file("install.sh")
  tags = {
      Name = "mysql-instance"
  }
}