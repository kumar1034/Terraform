module "vpc_module" {
  source = "./modules/aws_vpc"
  for_each = var.vpc_config
  vpc_cidr_block = each.value.vpc_cidr_block
  tags = each.value.tags
  
}

module "aws_subnet" {
  source = "./modules/aws_subnets"
  for_each = var.subnet_config
  vpc_id = module.vpc_module[each.value.vpc_name].vpc_id  
  vpc_cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = each.value.tags
}

module "internetGW_module" {
  
  source = "./modules/aws_InternetGW"

  for_each = var.internetGW_config

  vpc_id = module.vpc_module[each.value.vpc_name].vpc_id

  tags = each.value.tags
}


module "natGW_module" {
  
  source = "./modules/aws_natGW"

  for_each = var.natGW_config

  elasticIP_id = module.elastic_IP_module[each.value.eip_name].elasticIP_id
  
  subnet_id = module.aws_subnet[each.value.subnet_name].subnet_id

  tags = each.value.tags

}

module "elastic_IP_module" {
  
  source = "./modules/aws_elasticIP"

  for_each = var.elasticIP_config

  tags = each.value.tags
}

module "route_table_module" {
  
  source = "./modules/aws_route"

  for_each = var.route_table_config

  vpc_id = module.vpc_module[each.value.vpc_name].vpc_id  

  internetGW_id = each.value.private == 0 ? module.internetGW_module[each.value.gateway_name].internetGW_id : module.natGW_module[each.value.gateway_name].natGW_id

  tags = each.value.tags

}

module "route_table_association_module" {

 source = "./modules/aws_route_table_association"

 for_each = var.route_table_association_config

 subnet_id = module.aws_subnet[each.value.subnet_name].subnet_id

 route_table_id = module.route_table_module[each.value.route_table_name].route_table_id

}
