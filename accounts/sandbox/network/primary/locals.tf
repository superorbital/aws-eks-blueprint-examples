locals {
  vpc_cidr     = "10.42.0.0/16"
  vpc_name     = join("-", [var.tenant, var.environment, var.zone, "vpc"])
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
}
