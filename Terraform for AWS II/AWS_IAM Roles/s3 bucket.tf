#Create AWS S3 Bucket

resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-141" # name of the bucket 
  acl    = "private" #

  tags = {
    Name = "levelup-bucket-141"
  }
}

