# AWS-Security-Automation
# AWS Security Automation

## Overview
AWS Security Automation is a project designed to enhance cloud security by automating security monitoring, misconfiguration detection, and threat response within AWS environments. This project leverages AWS-native services, Python scripts, and security best practices to provide an automated security framework.

## Features
- **Automated Security Monitoring**: Real-time monitoring of AWS resources for security threats.
- **Misconfiguration Detection**: Identifies misconfigured AWS services such as open S3 buckets, overprivileged IAM roles, and security group vulnerabilities.
- **Threat Detection**: Uses AWS CloudTrail, GuardDuty, and custom Python scripts to detect anomalous activities.
- **Auto-Remediation**: Triggers Lambda functions to remediate security risks automatically.
- **Compliance Reporting**: Generates security compliance reports for AWS resources.

## Technologies Used
- **AWS Services**:
  - AWS Lambda
  - AWS CloudWatch
  - AWS IAM
  - AWS S3
  - AWS WAF
  - AWS GuardDuty
  - AWS Config
  - AWS Security Hub
- **Programming Languages**:
  - Python
  - Boto3 (AWS SDK for Python)

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Himangshu30/AWS-Security-Automation.git
   cd AWS-Security-Automation
   ```
2. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Configure AWS credentials:
   ```sh
   aws configure
   ```
4. Deploy the automation scripts using AWS Lambda or EC2.

## Usage
- Run security checks manually:
  ```sh
  python security_checker.py
  ```
- Deploy automated monitoring using AWS Lambda:
  - Upload the Lambda function script.
  - Configure necessary IAM roles and policies.
- View security reports in AWS Security Hub.

## Contributions
Contributions are welcome! If you have suggestions or improvements, feel free to submit a pull request.


## Contact
For any queries or support, reach out to **Himangshu Sarkar** at [GitHub](https://github.com/Himangshu30).
