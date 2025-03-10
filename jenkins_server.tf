
resource "aws_instance" "Jenkins_Server" {
    ami = "ami-0ace34e9f53c91c5d"
    instance_type   = "t2.micro"
    subnet_id       = aws_subnet.Jenkins_Subnets.id
    security_groups = [aws_security_group.Jenkins_SG.id]
    key_name        = "Terraform"
    root_block_device {
        volume_size           = 10  
        volume_type           = "gp3" 
        encrypted             = true  
        delete_on_termination = true  
    }
    tags = {
        Name = "Jenkins_Server"
    }
    user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
            sudo yum upgrade
            sudo yum install -y java-17-amazon-corretto
            sudo yum install jenkins -y
            sudo systemctl enable jenkins
            sudo systemctl start jenkins
            EOF   
    user_data_replace_on_change = false
    lifecycle {
        prevent_destroy = true
        ignore_changes  = all  # Ignore all changes
    }
}

output "jenkins_url" {
  value = "http://${aws_instance.Jenkins_Server.public_ip}:8080"
  description = "Access Jenkins using this URL"
}

