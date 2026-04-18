#!/bin/bash
# Update all installed packages
yum update -y

# Install Apache HTTPD and AWS CLI
yum install -y httpd aws-cli

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Sync the vervium UI from S3 to the web root
aws s3 sync s3://${bucket_name}/ /var/www/html/ --region ${aws_region}

# Ensure correct permissions
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/
