
resource "aws_instance" "grafana" {
  ami           = "ami-0056d98d3e05cdbd9"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public-subnet.id
  private_ip                  = "10.20.0.11"
  security_groups = [aws_security_group.grafana.id]
  availability_zone = "eu-west-1a"
  associate_public_ip_address = true
  user_data = "${file("install-grafana.sh")}"
  user_data_replace_on_change = true
  key_name = aws_key_pair.my-key.key_name

  tags = {
    Name = "grafana-server"
  }
}


resource "aws_instance" "prometheus" {
  ami           = "ami-0056d98d3e05cdbd9"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.private-subnet.id
  private_ip                  = "10.20.1.12"
  security_groups = [aws_security_group.prometheus.id]
  availability_zone = "eu-west-1a"
  user_data = "${file("install-prometheus.sh")}"
  user_data_replace_on_change = true
  key_name = aws_key_pair.my-key.key_name

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_instance" "workers" {
  count         = 2
  ami           = "ami-0056d98d3e05cdbd9"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.private-subnet.id
  private_ip = count.index == 0 ? "10.20.1.13" : "10.20.1.14"
  security_groups = [aws_security_group.worker.id]
  availability_zone = "eu-west-1a"
 #user_data = "${file("install-prometheus.sh")}"
 #user_data_replace_on_change = true
  key_name = aws_key_pair.my-key.key_name

  tags = {
    Name = "Worker-${count.index + 1}"
  }
}



resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file("key.pub")  
}





# Generate inventory file for Ansible

 resource "local_file" "inventory" {
   filename = "../ansible/inventory"
   content  = <<EOT
 [grafana]
 ${aws_instance.grafana.public_ip}
 ${aws_instance.grafana.private_ip}

 [prometheus]
 ${aws_instance.prometheus.public_ip}
 ${aws_instance.prometheus.private_ip}
 EOT
 }

