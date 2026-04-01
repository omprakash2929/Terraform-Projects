# key pair (login)
resource "aws_key_pair" "Infra-deployer" {
    key_name = "${var.env}-Infra-app-key"
    public_key = file("./terra.pub")

    tags={
        Environment = var.env
    }
}

# VPC & Security Group

resource aws_default_vpc default {
    
}

resource "aws_security_group" "infra_security_group" {
  name = "${var.env}-Infra-sg"
  description = "This will add a TF genrate Security group"
  vpc_id = aws_default_vpc.default.id  #interpolation
  tags ={
    Name = "automate-sg"
  }

  #! inbound Rules
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Port 22 is open "
  }

  #! outbound Rules
  egress  {
    from_port = 0 
    to_port = 0
    protocol = -1
    description = "All access open."
  }
}


# EC2 Instance

resource aws_instance my_instance {
    count = var.instance_count
    key_name = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type =  var.Ec2_instance_type  #! use variable to get value
    ami = var.Ec2_ami_id  #? ubuntu ami id 

    root_block_device {
      volume_size = var.env == "prd" ? 20 : var.ec2_deafult_root_storage_size
      volume_type = "gp3"
    }
    
    tags = {
        Name = "${var.env}-Infra-EC2"
    }
}   