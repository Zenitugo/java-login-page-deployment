##################### EC2 CREATION  #############################
resource "aws_instance" "web" {
  count  = 2  
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.testkey.id
  subnet_id = [var.frontend-subnet, var.backend-subnet][count.index]
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.instance_name
  }
}


############### KEY CREATION ##########################
# Create a key pair
resource "aws_key_pair" "testkey" {
  key_name = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create a Private key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Put the private key in a local file
resource "local_file" "testkey_private" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = var.key_filename
}



############### SECURITY GROUP CREATION ###########################

# CREATE A SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = var.sg
  vpc_id      = var.vpc-id
  

  
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
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

  tags = {
    Name = "allow_tcp"
  }
}



#  RDS SECURITY GROUP
resource "aws_security_group" "rds-sg" {
  name        = var.rds-sg
  vpc_id      = var.vpc-id
  

  
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}