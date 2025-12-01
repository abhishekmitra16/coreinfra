module "vpc" {
  source           = "./modules/vpc"
  project_name     = var.project_name
  vpc_name         = var.vpc_name
  alb_sg_id        = module.alb.alb_sg_id
  application_port = var.application_port
}


module "vpce" {
  source                   = "./modules/vpce"
  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  vpc_cidr                 = module.vpc.vpc_cidr_block
  region                   = var.region
  private_subnet_ids       = module.vpc.private_subnet_ids
  private_route_table_ids  = module.vpc.private_route_table_ids
}

module "alb" {
  source                   = "./modules/alb"
  project_name             = var.project_name
  domain_name              = var.domain_name
  sub_domain_name          = var.sub_domain_name
  vpc_id                   = module.vpc.vpc_id
  application_port         = var.application_port
  alb_name                 = var.alb_name
  alb_exists               = var.alb_exists
  use_existing_certificate = var.use_existing_certificate
#   route53_zone_id          = module.route53.route53_zone_id
  public_subnet_ids        = module.vpc.public_subnet_ids
}


module "cloudfront" {
  source                  = "./modules/cloudfront"
  project_name            = var.project_name
  s3_origin_id            = module.s3.s3_origin_id
  s3_regional_domain_name = module.s3.s3_regional_domain_name
  backend_alb_dns_name    = module.alb.alb_dns_name
  cloudfront_oac_id       = module.s3.cloudfront_oac_id
  # acm_certificate_arn     = module.alb.acm_certificate_arn
  domain_name             = var.domain_name
  sub_domain_name         = var.sub_domain_name
}


module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "ecs" {
  source                = "./modules/ecs"
  project_name          = var.project_name
  region                = var.region
  log_retention_days    = var.log_retention_days
  ecs_cpu               = var.ecs_cpu
  ecs_memory            = var.ecs_memory
  container_name        = var.container_name
  initial_image_exists  = var.initial_image_exists
  private_sample_image  = var.private_sample_image
  repository_url        = module.ecr.repository_url
  image_tag             = var.image_tag
  application_port      = var.application_port
  desired_count         = var.desired_count
  public_subnet_ids     = module.vpc.public_subnet_ids
  ecs_security_group_id = module.vpc.ecs_security_group_id
  target_group_arn      = module.alb.alb_target_group_arn
  cluster_exists        = var.cluster_exists
  existing_cluster_name = var.existing_cluster_name
  cluster_name          = var.cluster_name
  private_subnet_ids    = module.vpc.private_subnet_ids
}

module "rds" {
  source                 = "./modules/rds"
  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  db_instance_identifier = var.db_instance_identifier
  database_name          = var.database_name
  database_port          = var.database_port
  db_username            = module.secrets.db_username
  db_password            = module.secrets.db_master_password
  secret_version_id      = module.secrets.secret_version_id
  rds_security_group_id  = module.rds_sg.rds_sg_id
}

module "rds_proxy" {
  source                        = "./modules/rds_proxy"
  project_name                  = var.project_name
  rds_proxy_name                = var.rds_proxy_name
  vpc_id                        = module.vpc.vpc_id
  database_name                 = var.database_name
  database_port                 = var.database_port
  private_subnet_ids            = module.vpc.private_subnet_ids
  aws_secret_db_credentials_arn = module.secrets.aws_secret_db_credentials_arn
  aws_db_instance_identifier    = module.rds.db_instance_identifier
  rds_proxy_security_group_id   = module.rds_sg.rds_proxy_sg_id
}

module "rds_sg" {
  source                = "./modules/rds_sg"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  rds_sg_name           = var.rds_sg_name
  ecs_security_group_id = module.vpc.ecs_security_group_id

}

# module "route53" {
#   source                 = "./modules/route53"
#   domain_name            = var.domain_name
#   sub_domain_name        = var.sub_domain_name
#   cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
#   cloudfront_zone_id     = module.cloudfront.cloudfront_zone_id
# }

module "route53_private" {
  source                   = "./modules/route53_private"
  project_name             = var.project_name
  private_hosted_zone_name = module.vpc.private_hosted_zone_name
  vpc_id                   = module.vpc.vpc_id
  alb_dns_name             = module.alb.alb_dns_name
  alb_zone_id              = module.alb.alb_zone_id
  rds_proxy_endpoint       = module.rds_proxy.proxy_endpoint
}

module "s3" {
  source                      = "./modules/s3"
  project_name                = var.project_name
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "secrets" {
  source                   = "./modules/secrets"
  project_name             = var.project_name
  private_hosted_zone_name = module.vpc.private_hosted_zone_name
  database_name            = var.database_name
  database_port            = var.database_port
}

