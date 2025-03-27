#!/bin/bash
# Simulates GuardDuty finding
aws lambda invoke --function-name SecurityRemediation \
    --payload file://<(echo '{
        "detail-type": "GuardDuty Finding",
        "detail": {
            "type": "UnauthorizedAccess:IAMUser",
            "severity": 8,
            "resource": {
                "accessKeyDetails": {
                    "userName": "malicious-user"
                }
            }
        }
    }') response.json

cat response.json
