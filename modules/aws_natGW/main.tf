resource "aws_nat_gateway" "aNGW" {
  allocation_id = var.elasticIP_id
  subnet_id     = var.subnet_id
  tags = var.tags
}
