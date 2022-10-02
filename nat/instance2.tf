locals {
 
  ssh_user         = "ubuntu"
  key_name         = "test"
  private_key_path = "~/Downloads/test.pem"
}


resource "aws_security_group" "nginx" {
  name   = "nginx_access"
  vpc_id =  aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  depends_on = [
    aws_instance.instance-mysql
  ]
  ami                         = "ami-062df10d14676e201"
  subnet_id                   = aws_subnet.public_subnet.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = local.key_name


  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
  }
}

# creating dynamic inventory for multiple instances
# resource "null_resource" "provisioner" {
#   count = "${var.count}"

#   triggers {
#     master_id = "${element(aws_instance.my_instances.*.id, count.index)}"
#   }

#   connection {
#     host        = "${element(aws_instance.my_instances.*.private_ip, count.index)}"
#     type        = "ssh"
#     user        = "..."
#     private_key = "..."
#   }

#   # set hostname
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'multiple instances'"
#     ]
#   }
# }

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}