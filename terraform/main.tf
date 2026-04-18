# ============================================================================
# Network Infrastructure
# ============================================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vervium-pipeline-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vervium-pipeline-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "vervium-pipeline-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "vervium-pipeline-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ============================================================================
# Security Configuration
# ============================================================================

resource "aws_security_group" "web_server" {
  name        = "vervium-pipeline-web-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vervium-pipeline-web-sg"
  }
}

# ============================================================================
# S3 Bucket for Vervium UI
# Private bucket — EC2 accesses it via IAM role
# ============================================================================

resource "aws_s3_bucket" "vervium_ui" {
  bucket_prefix = "vervium-ui-"

  tags = {
    Name = "vervium-ui"
  }
}

resource "aws_s3_bucket_public_access_block" "vervium_ui" {
  bucket = aws_s3_bucket.vervium_ui.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload all vervium UI files, preserving directory structure
resource "aws_s3_object" "vervium_ui_files" {
  for_each = fileset("${path.module}/vervium_ui", "**")

  bucket = aws_s3_bucket.vervium_ui.id
  key    = each.value
  source = "${path.module}/vervium_ui/${each.value}"
  etag   = filemd5("${path.module}/vervium_ui/${each.value}")

  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "ico"  = "image/x-icon"
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

# ============================================================================
# IAM Role for EC2 to access S3
# ============================================================================

resource "aws_iam_role" "web_server" {
  name = "vervium-pipeline-web-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "web_server_s3" {
  name = "vervium-ui-s3-read"
  role = aws_iam_role.web_server.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.vervium_ui.arn,
        "${aws_s3_bucket.vervium_ui.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "web_server" {
  name = "vervium-pipeline-web-server-profile"
  role = aws_iam_role.web_server.name
}

# ============================================================================
# Compute Resources
# ============================================================================

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.web_server.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data = templatefile("${path.module}/user-data.sh", {
    bucket_name = aws_s3_bucket.vervium_ui.id
    aws_region  = var.aws_region
  })

  user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "vervium-pipeline-web-server"
  }
}
