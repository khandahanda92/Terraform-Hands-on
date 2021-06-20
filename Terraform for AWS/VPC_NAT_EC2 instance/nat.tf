## Defining the nat gateway 
#Define External IP 
resource "aws_eip" "levelup-nat" {  # name of the external ip resource 
  vpc = true
}

# Now define the public sunet dependacy with the interet gateway 
resource "aws_nat_gateway" "levelup-nat-gw" { # name of nat gateway 
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id # Defining first public subnet id 
  depends_on    = [aws_internet_gateway.levelup-gw]
  # It will depend on the interet gateway 
}


# Now we need to setup the vpc for the nat gateway so that the outer machines cannot access my machine 
# Meas the machine which are present on internet cannot access machine of my project 
# Although my aws machines can acess the internet but the reverse traffic will not be allowed 
resource "aws_route_table" "levelup-private" { # name of my route table 
  vpc_id = "aws_vpc.levelupvpc.id"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }

  tags = {
    Name = "levelup-private"
  }
}

# route associations private
resource "aws_route_table_association" "level-private-1-a" { # association name 
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  # here we are defining the private subnet id 
  route_table_id = aws_route_table.levelup-private.id
  # We are defining the association with the nat gateway with the private subnet 
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.levelupvpc-private-2.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.levelupvpc-private-3.id
  route_table_id = aws_route_table.levelup-private.id
}