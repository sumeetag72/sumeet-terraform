aws_account_id                 ="276164198880"
region                         = "us-east-1"
profile                        = "276164198880_GL-ReleaseEngg"
environment                    = "dev"
project                        = "seahorse"
register_component_lambda_name = "RegisterComponentLambda"
get_components_lambda_name     = "GetRegisteredComponents"
delete_component_lambda_name   = "DeleteRegisteredComponent"
create_preference_lambda_name = "SaveUserPreference"
get_preference_lambda_name = "GetUserPreference"
delete_preference_lambda_name = "DeleteUserPreference"
app_definitions_table_name        = "FSBL_COMPONENTS"
user_preferences_table_name        = "USER_PREFERENCES"
idp-name                       = "Globallink"
user_pool_arn                  ="arn:aws:cognito-idp:us-east-1:276164198880:userpool/us-east-1_xWPX0bsC5"
user-pool-client-redirect-urls =["http://localhost:3000,http://localhost:3375/local.seahorse.finsemble/components/seahorseAuthentication/SeahorseAuthentication.html,https://web.seahorse-dev.globallink.com/components/seahorseAuthentication/SeahorseAuthentication.html"]
user-pool-client-logout-urls   =["http://localhost:3000,http://localhost:3375/local.seahorse.finsemble/components/seahorseAuthentication/SeahorseAuthentication.html,https://web.seahorse-dev.globallink.com/components/seahorseAuthentication/SeahorseAuthentication.html"]
domain_name="seahorse-dev.globallink.com"
hosted_zone_id="Z0320195LYBDR90JCDMB"
acm_certificate_arn="arn:aws:acm:us-east-1:276164198880:certificate/f35645d3-d3e2-4d12-9fc4-96e019ce97ea"
whitelisted_ips=["208.89.236.196/32","74.204.251.4/32","74.204.251.4/32","159.18.234.5/32","159.18.234.12/32","208.89.239.4/32","208.89.239.5/32","63.106.110.9/32","63.106.110.14/32","185.84.23.5/32","208.89.239.4/32","165.225.39.0/24","165.225.38.0/24","165.225.220.0/24","147.161.166.0/24","10.20.54.0/24","213.249.226.56/32","80.192.239.232/32","118.238.204.120/32","219.164.207.18/32","81.196.151.13/32","203.80.6.50/32"]
auth_domain_name="d14qhha1mbc1wy.cloudfront.net"
web_api_zone_id="Z2FDTNDATAQYW2"
web_api_domain_name="d1kdnzm3viay1x.cloudfront.net"
admin_api_zone_id="Z1UJRXOUMOOFQ8"
admin_api_domain_name="d-98anqe8ak6.execute-api.us-east-1.amazonaws.com"
admin_api_id="olf4b7brbf"
seahorse_admin_group_id="*"
ssa_group_id="ssa"
bestx_group_id="bestx"
tradenexus_group_id="tradenexus"
fxconnect_group_id="fxconnect"
configure_route53 = false
deploy_auth = false
docs-user-pool-client-redirect-urls =["https://storybook.seahorse-dev.globallink.com,https://docusaurus.seahorse-dev.globallink.com"]
docs-user-pool-client-logout-urls   =["https://storybook.seahorse-dev.globallink.com,https://docusaurus.seahorse-dev.globallink.com"]
docs_auth_domain="docs-seahorse-dev"
login-css=<<EOT
.background-customizable {
    background-color: #EBEBEB;
}
.banner-customizable {
  background-color: #FFF;
}
.errorMessage-customizable {
  border: 1px solid #FF5A5A;
}
.idpButton-customizable {
  background-color: #0166B9;
  color: #FFFFFF;
  border-color: transparent;
}
.idpButton-customizable:hover {
  background-color: #013E7D;
  color: #FFFFFF;
}
.inputField-customizable {
  color: #333333;
  background-color: #ECECEC;
  border: 1px solid #5F5F5F;
}
.inputField-customizable:focus {
  border: 1px solid #A2C0D8;
}
.legalText-customizable {
  color: #5F5F5F;
}
.submitButton-customizable {
  background-color: #0166B9;
  color: #FFFFFF;
  height: 36px;
}
.submitButton-customizable:hover {
  background-color: #013E7D;
  color: #FFFFFF;
} 
EOT
