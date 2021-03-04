aws_account_id                 ="276164198880"
region                         = "us-east-1"
profile                        = "276164198880_GL-ReleaseEngg"
environment                    = "dev"
project                        = "seahorse"
register_component_lambda_name = "RegisterComponentLambda"
get_components_lambda_name     = "GetRegisteredComponents"
delete_component_lambda_name   = "DeleteRegisteredComponent"
dynamo_admin_table_name        = "FSBL_CONFIG"
idp-name                       = "Globallink"
user_pool_arn                  ="arn:aws:cognito-idp:us-east-1:276164198880:userpool/us-east-1_xWPX0bsC5"
user-pool-client-redirect-urls =["http://localhost:3375/local.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html,https://s3.amazonaws.com/dev.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html"]
user-pool-client-logout-urls   =["http://localhost:3375/local.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html, https://s3.amazonaws.com/dev.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html"]
domain_name="seahorse-dev.globallink.com"
hosted_zone_id="Z0320195LYBDR90JCDMB"
acm_certificate_arn="arn:aws:acm:us-east-1:276164198880:certificate/f35645d3-d3e2-4d12-9fc4-96e019ce97ea"
whitelisted_ips=["208.89.236.196/32","74.204.251.4/32","74.204.251.4/32","159.18.234.5/32","159.18.234.12/32","208.89.239.4/32","208.89.239.5/32","63.106.110.9/32","63.106.110.14/32","185.84.23.5/32","208.89.239.4/32","165.225.39.0/24","165.225.38.0/24","165.225.220.0/24","147.161.166.0/24","10.20.54.0/24","213.249.226.56/32","80.192.239.232/32"]
configure_route53=false