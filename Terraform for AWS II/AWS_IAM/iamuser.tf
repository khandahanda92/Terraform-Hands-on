#TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" { # defining the aws resource and the variable 
  name = "adminuser1"  # name of the iam user 
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2" # name of uses 
}

# Group TF Definition
resource "aws_iam_group" "admingroup" {
  name = "admingroup"
}

#Assign User to AWS Group
resource "aws_iam_group_membership" "admin-users" {
  name = "admin-users"
  users = [
    aws_iam_user.adminuser1.name,
    aws_iam_user.adminuser2.name,
    
# Defining the list of users which i want to keep in this group membership 
  ]
  group = aws_iam_group.admingroup.name  # this is the group name in which these users are assigned 
}

#Policy for AWS Group
resource "aws_iam_policy_attachment" "admin-users-attach" {
  name       = "admin-users-attach"
  groups     = [aws_iam_group.admingroup.name] # list of the group on which this policy is applied 
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  # I am defining the administrative acess on this group 
}

## Do not use the terraform destroy in this case 