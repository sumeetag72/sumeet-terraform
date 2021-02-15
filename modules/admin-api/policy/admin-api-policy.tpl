{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${api_execution_arn}/*/*/*"
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${api_execution_arn}/*/*/*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": [
                        "208.89.236.196/32",
                        "74.204.251.4/32",
                        "74.204.251.5/32",
                        "159.18.234.5/32",
                        "159.18.234.12/32",
                        "208.89.239.4/32",
                        "208.89.239.5/32",
                        "63.106.110.9/32",
                        "63.106.110.14/32",
                        "185.84.23.5/32",
                        "165.225.39.83/32",
                        "147.161.166.83/32"
                    ]
                }
            }
        }
    ]
}