{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SeahorseDev",
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": [
                "arn:aws:execute-api:us-east-1:${aws_account_id}:${admin_api_id}/*/*/apps/group/${group_id}"
            ]
        },
        {
            "Sid": "ListSeahorseApps",
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": [
                "arn:aws:execute-api:us-east-1:${aws_account_id}:${admin_api_id}/*/*/apps/group"
            ]
        }
    ]
}