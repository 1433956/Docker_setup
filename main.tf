resource "aws_instance" "main" {
  ami           = local.ami_id
  #instance_type = "t3.micro"
  instance_type = "t3.medium"
  vpc_security_group_ids =[aws_security_group.main.id] 
   
 root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("docker.sh")
  tags = {
   Name = "${var.project}-${var.environment}-docker"
  }
}

resource "aws_security_group" "main" {
  name        = "allow_all"
  description = "Allow TLS inbound traffic and all outbound traffic"
  
ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  
    lifecycle {
      create_before_destroy = true
    }

  tags = {
    Name = "allow-all-docker"
  }
}

