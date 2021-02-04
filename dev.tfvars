aws_account_id                 ="276164198880"
region                         = "us-east-1"
profile                        = "276164198880_GL-ReleaseEngg"
environment                    = "dev"
project                        = "seahorse"
register_component_lambda_name = "RegisterComponentLambda"
get_components_lambda_name = "GetRegisteredComponents"
delete_component_lambda_name = "DeleteRegisteredComponent"
dynamo_admin_table_name = "FSBL_CONFIG"
idp-name = "Globallink"
user_pool_arn="arn:aws:cognito-idp:us-east-1:276164198880:userpool/us-east-1_xWPX0bsC5"
user-pool-client-redirect-urls=["http://localhost:3375/local.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html,https://s3.amazonaws.com/dev.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html"]
user-pool-client-logout-urls=["http://localhost:3375/local.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html, https://s3.amazonaws.com/dev.seahorse.finsemble/components/seaHorseAuthentication/SeaHorseAuthentication.html"]