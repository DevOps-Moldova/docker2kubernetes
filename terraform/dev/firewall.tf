resource "aws_security_group" "allow_outgoing_traffic" {
  name        = "${var.cluster_name}-allow-outgoing-traffic"
  description = "allow_outgoing_traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "allow_http" {
  name        = "${var.cluster_name}-allow-http"
  description = "allow_http"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "whitelisted_traffic" {
  name        = "${var.cluster_name}-whitelisted-traffic"
  description = "Whitelisted traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "all acces cf"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.trusted_ip
  }

  tags = local.tags
}

resource "aws_security_group" "internal_traffic" {
  name        = "${var.cluster_name}-internal-traffic"
  description = "Allow internal traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "all internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = concat(
      [var.vpc_cidr],
      local.vpc_public_ips
    )
  }

  tags = local.tags
}