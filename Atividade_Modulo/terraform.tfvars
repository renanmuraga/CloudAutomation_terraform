# module "slackoapp" {
# source = "./modules/slacko-app"
# vpc_id = "Pegar na console da AWS"
# subnet_cidr = var.subnet_cidr ou a default
# name = Nome dos recursos
# app_tags = Lista de tags em que todos os recursos deverão possuir
# }

vpc_id = "vpc_id"
subnet_cidr = "10.0.102.0/24"
name_prefix = "renanmuraga"
app_tags = {projeto = "slacko-app"}
slacko-sshkey = "arquivo key.pub - colocar o valor aqui"
