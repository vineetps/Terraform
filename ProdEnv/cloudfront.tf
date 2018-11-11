resource "aws_cloudfront_distribution" "cdn" {
  price_class  = "PriceClass_All"
  http_version = "http2"
  "origin" {
    origin_id   = "ELB-${aws_elb.PublicElb.name}"
    domain_name = "${aws_elb.PublicElb.dns_name}"
    origin_path = "/root"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }
  enabled             = true
  logging_config {
    include_cookies = true
    bucket          = "${aws_s3_bucket.bucket-logs.bucket}.s3.amazonaws.com"
    prefix          = "cloudfront/"
  }
  "default_cache_behavior" {
    allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    "forwarded_values" {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl          = "21600"
    default_ttl      = "86400"
    max_ttl          = "31536000"
    target_origin_id = "ELB-${aws_elb.PublicElb.name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }
  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }
  "viewer_certificate" {
    cloudfront_default_certificate = true
    minimum_protocol_version = "TLSv1.1_2016"
  }
  tags {
    Namw    = "cdn"
  }
}
