resource "aws_s3_bucket" "Remote-s3" {
  bucket = "Terra-infra"

  tags={
    Name = "Terra-infra"
    Environment = "dev"
  }
}