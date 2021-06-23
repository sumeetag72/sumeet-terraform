aws_account_id                 = "522478937547"
region                         = "us-east-1"
profile                        = "522478937547_GL-ReleaseEngg"
environment                    = "dev2"
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
user_pool_arn                  ="arn:aws:cognito-idp:us-east-1:522478937547:userpool/us-east-1_stFcSjlRj"
user-pool-client-redirect-urls =["http://localhost:3375/local.seahorse.finsemble/components/seahorseAuthentication/SeahorseAuthentication.html,https://web.seahorse-dev2.globallink.com/components/seahorseAuthentication/SeahorseAuthentication.html"]
user-pool-client-logout-urls   =["http://localhost:3375/local.seahorse.finsemble/components/seahorseAuthentication/SeahorseAuthentication.html,https://web.seahorse-dev2.globallink.com/components/seahorseAuthentication/SeahorseAuthentication.html"]
domain_name="seahorse-dev2.globallink.com"
hosted_zone_id="Z0389083286VLGKJXVSLH"
acm_certificate_arn="arn:aws:acm:us-east-1:522478937547:certificate/b8185219-3b87-4912-bd4b-76715fe66627"
whitelisted_ips=["208.89.236.196/32","74.204.251.4/32","74.204.251.4/32","159.18.234.5/32","159.18.234.12/32","208.89.239.4/32","208.89.239.5/32","63.106.110.9/32","63.106.110.14/32","185.84.23.5/32","208.89.239.4/32","165.225.39.0/24","165.225.38.0/24","165.225.220.0/24","147.161.166.0/24","10.20.54.0/24","213.249.226.56/32","80.192.239.232/32"]
auth_domain_name="d14qhha1mbc1wy.cloudfront.net"
web_api_zone_id="Z2FDTNDATAQYW2"
web_api_domain_name="d26njnwim6trtg.cloudfront.net"
admin_api_zone_id="Z2FDTNDATAQYW2"
admin_api_domain_name="dp378tsmnrdmn.cloudfront.net"
admin_api_id="0r4pevmvt5"
seahorse_admin_group_id="*"
ssa_group_id="ssa"
bestx_group_id="bestx"
tradenexus_group_id="tradenexus"
fxconnect_group_id="fxconnect"
configure_route53 = false
deploy_auth = false
ocs-user-pool-client-redirect-urls =["https://storybook.seahorse-dev2.globallink.com,https://docusaurus.seahorse-dev2.globallink.com"]
docs-user-pool-client-logout-urls   =["https://storybook.seahorse-dev2.globallink.com,https://docusaurus.seahorse-dev2.globallink.com"]
docs_auth_domain="docs-seahorse-dev2"
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