
output "jenkins_server_public_ip" {
  value = aws_instance.Jenkins_Server.public_ip
}

variable "agent_secret" {
  description = "Jenkins agent secret"
  type        = string
  sensitive   = true
}

variable "agent_name" {
  description = "Jenkins agent name"
  type        = string
}

resource "aws_instance" "Jenkins_Agent" {
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
        Name = "Jenkins_Agent"
    }
    user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y java-17-amazon-corretto
            JENKINS_URL="http://${aws_instance.Jenkins_Server.public_ip}:8080"
            WORK_DIR="/home/jenkins"
            AGENT_SECRET="${var.agent_secret}"
            AGENT_NAME="${var.agent_name}"
            mkdir -p "$WORK_DIR"
            cd "$WORK_DIR"
            curl -sO "$JENKINS_URL/jnlpJars/agent.jar"
            exec java -jar agent.jar -url "$JENKINS_URL" -secret "$AGENT_SECRET" -name "$AGENT_NAME" -webSocket -workDir "$WORK_DIR"
            EOF   
    user_data_replace_on_change = false
    depends_on = [ aws_instance.Jenkins_Server ]
}
