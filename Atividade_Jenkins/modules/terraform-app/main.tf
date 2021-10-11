data "aws_ami" "jenkins" {
  most_recent = true
  owners = ["099720109477"]
  
  filter {
   name = "name"
   values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"]
}
  filter {
   name = "architecture"
   values= ["x86_64"]
}

}
data "aws_subnet" "subnet_public" { 
  cidr_block = var.subnet_cidr
}

resource "aws_key_pair" "jenkins-sshkey" {
     key_name = format("%s-jenkins-app-key", var.name_prefix)
     public_key = var.jenkins-sshkey 

#ssh-keygen -C -f slacko

}

resource "aws_instance" "jenkins" {
connection {
        user = "ubuntu"
        host = "${self.public_ip}"
        type     = "ssh"
        private_key = "${file("/home/vagrant/terraform-app/slacko")}"
      }
   vpc_security_group_ids = [aws_security_group.allow-jenkins.id]
   ami = data.aws_ami.jenkins.id
   instance_type = var.instance_type
   subnet_id = data.aws_subnet.subnet_public.id
   associate_public_ip_address = true

  tags = merge(var.app_tags,
            {
            "Name" = format("%s-jenkins-app", var.name_prefix)
            })
  key_name = aws_key_pair.jenkins-sshkey.id
  user_data_base64 = "CHAVE PUBLICA"  
  provisioner "remote-exec" {
    inline = [
      "sleep 600",
      "echo \"Chave Jenkins: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)\""
    ]
 }
}

resource "aws_security_group" "allow-jenkins" {
  name        =  format("%s-allow-ssh-8080", var.name_prefix)
  description = "Allow ssh and 8080 port"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "allow ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }, 
    {
      description      = "allow http"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }

  ]

  egress = [ 
    {
      description      = "saida"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }
  ]

  tags = merge(var.app_tags,
            {
            "Name" = format("%s-allow_ssh_8080", var.name_prefix)
            })
}


