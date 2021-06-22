#Roles to access the AWS S3 Bucket
resource "aws_iam_role" "s3-levelupbucket-role" { # here we are defining the roles 
  name               = "s3-levelupbucket-role" # name of the role 
  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  )

}
#The above role is defining for tje service ec2 

#Policy to attach the S3 Bucket Role
resource "aws_iam_role_policy" "s3-levelupmybucket-role-policy" {
  name = "s3-levelupmybucket-role-policy"
  role = aws_iam_role.s3-levelupbucket-role.id # on which this policy will be applied 
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::levelup-bucket-1992",
              "arn:aws:s3:::levelup-bucket-1992/*"
            ]
        }
    ]
}
EOF

}

# In the resource section i am defining the resources which will be accessible by this policy 
# First is the bucket name and 2nd is for the all the contents which is present inside the bucket 
# so we are defining the access on the bucket and the content of the bucket 


# How we can attach that particular role to the EC2 instance ?
#Instance identifier
resource "aws_iam_instance_profile" "s3-levelupbucket-role-instanceprofile" {
  name = "s3-levelupbucket-role"
  role = aws_iam_role.s3-levelupbucket-role.name  
}