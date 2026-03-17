data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "devops-key"
  public_key = file(pathexpand("~/.ssh/devops_project_key.pub"))
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"

  # 1. Attach the SSH Key
  key_name = aws_key_pair.deployer.key_name

  # 2. Put the server in Subnet
  subnet_id = aws_subnet.public_subnet.id

  # 3. Firewall
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "devops-visitor-server"
  }
}

