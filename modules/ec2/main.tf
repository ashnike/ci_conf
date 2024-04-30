resource "tls_private_key" "pri_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "pipelines"
  public_key = tls_private_key.pri_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pri_key.private_key_pem}' > ./jenkins.pem"
  }
}


resource "tls_private_key" "pri_key_2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair_2" {
  key_name   = "nexus"
  public_key = tls_private_key.pri_key_2.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pri_key_2.private_key_pem}' > ./nexus.pem"
  }
}

resource "tls_private_key" "pri_key_3" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair_3" {
  key_name   = "sonarqube"
  public_key = tls_private_key.pri_key_3.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pri_key_3.private_key_pem}' > ./sonarqube.pem"
  }
}




# Use VPC and subnets from the module
resource "aws_instance" "jenkins_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type_jenkins
  subnet_id       = var.public_subnet_ids[0] # Assuming there's only one subnet
  security_groups = [aws_security_group.jenkins_sg.id]
  key_name        = aws_key_pair.keypair.key_name
  iam_instance_profile = var.instance_profile_name
  depends_on = [aws_security_group.jenkins_sg]
  tags = {
    Name = "jenkins-server" 
    Project     = "jenkins"
  }
}


resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id 
  name        = "jenkins-sg" 
  description = "jenkins server sg"
  // Define inbound rules for Jenkins
  ingress {
    from_port   = 8080   // jenkins port
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Define inbound rules for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Define outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "nexus_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type_nexus
  subnet_id       = var.public_subnet_ids[0] 
  security_groups = [aws_security_group.nexus_sg.id]
  key_name        = aws_key_pair.keypair_2.key_name
  iam_instance_profile = var.instance_profile_name
  depends_on = [aws_security_group.nexus_sg]
   tags = {
    Name = "Nexus-server" 
    Project = "nexus"
  }
}

resource "aws_security_group" "nexus_sg" {
  vpc_id = var.vpc_id 
  name        = "Nexus-sg" 
  description = "nexus server sg"
  // Define inbound rules for Nexus
  ingress {
    from_port   = 8081 # nexus port
    to_port     = 8081 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    // Define inbound rules for SSH
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
  // Define outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarqube_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type_sonarqube
  subnet_id       = var.public_subnet_ids[0] # Assuming there's only one subnet
  security_groups = [aws_security_group.sonarqube_sg.id]
  key_name        = aws_key_pair.keypair_3.key_name
  iam_instance_profile = var.instance_profile_name
  depends_on = [aws_security_group.sonarqube_sg]
   tags = {
    Name = "Sonarqube-server"  
    Project = "sonarqube"
  }
}
resource "aws_security_group" "sonarqube_sg" {
  vpc_id = var.vpc_id 
  name        = "sonarqube-sg" 
  description = "sonarqube server sg"
  // Define inbound rules for SonarQube
  ingress {
    from_port   = 9000 // sonarqube port
    to_port     = 9000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    // Define inbound rules for SSH
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

  // Define outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
