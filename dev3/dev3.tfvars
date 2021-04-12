aws_account_id                 = "073724527903"
region                         = "us-east-1"
profile                        = "073724527903_GL-ReleaseEngg"
environment                    = "dev3"
project                        = "seahorse"
register_component_lambda_name = "RegisterComponentLambda"
get_components_lambda_name     = "GetRegisteredComponents"
delete_component_lambda_name   = "DeleteRegisteredComponent"
dynamo_admin_table_name        = "FSBL_CONFIG"
idp-name                       = "Globallink"
user_pool_arn                  ="arn:aws:cognito-idp:us-east-1:522478937547:userpool/us-east-1_stFcSjlRj"
user-pool-client-redirect-urls =["https://web.seahorse-dev3.globallink.com/components/seaHorseAuthentication/SeaHorseAuthentication.html"]
user-pool-client-logout-urls   =["https://web.seahorse-dev3.globallink.com/components/seaHorseAuthentication/SeaHorseAuthentication.html"]
domain_name="seahorse-dev3.globallink.com"
hosted_zone_id="Z02881432VIQ39T2K6SQK"
acm_certificate_arn="arn:aws:acm:us-east-1:522478937547:certificate/b8185219-3b87-4912-bd4b-76715fe66627"
whitelisted_ips=["208.89.236.196/32","74.204.251.4/32","74.204.251.4/32","159.18.234.5/32","159.18.234.12/32","208.89.239.4/32","208.89.239.5/32","63.106.110.9/32","63.106.110.14/32","185.84.23.5/32","208.89.239.4/32","165.225.39.0/24","165.225.38.0/24","165.225.220.0/24","147.161.166.0/24","10.20.54.0/24","213.249.226.56/32","80.192.239.232/32","118.238.204.120/32","219.164.207.18/32","81.196.151.13/32","203.80.6.50/32"]
configure_route53 = true
deploy_auth = true