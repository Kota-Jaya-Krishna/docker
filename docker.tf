resource "aws_instance" "expense" {
  ami                    = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  instance_type          = "t3.micro"

  # 20GB is not enough
  root_block_device {
    volume_size = 50    # Set root volume size to 50GB
    volume_type = "gp3" # Use gp3 for better performance (optional)
  }
  user_data = file("docker.sh")
  tags = {
    Name    = "docker"
    purpose = "Docker-Projectice"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic and all outbound traffic"

  # Allow All Traffic (All Ports) (since protocol = "-1").

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #  Allow HTTP (Port 80). Allows incoming TCP traffic only on port 80 from anywhere.

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Outbound Traffic. Allows outbound traffic on all ports and all protocols.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls_new"
  }
}

output "docker_ip" {
  value = aws_instance.expense.public_ip
}
