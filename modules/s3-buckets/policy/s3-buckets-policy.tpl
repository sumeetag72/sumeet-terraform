{
    "Version": "2012-10-17",
    "Id": "SourceIPAllowed",
    "Statement": [
        {
            "Sid": "VPCe and SourceIP",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:Get*",
            "Resource": [
                "arn:aws:s3:::${bucket_name}",
                "arn:aws:s3:::${bucket_name}/*"
            ],
            "Condition": {
                "IpAddress": {
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
                        "208.89.239.4/32",
                        "165.225.39.83/16"
                    ]
                }
            }
        }
    ]
}