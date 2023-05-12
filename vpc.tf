resource "aws_vpc" "vpc1"{
	cidr_block=var.v_vpc_cidr
	tags=merge(var.v_comm_tags,{"Name"="MYSheshivardhan"})
}
resource "aws_eip" "myeip"{
	count=0
}

resource "aws_subnet" "sn1"{
	cidr_block=var.v_sn1_cidr
	vpc_id=aws_vpc.vpc1.id
	availability_zone=var.v_sn1_az
	tags=merge(var.v_comm_tags,{"Name"="PubSN1-MYVPC1"})
	
}
resource "aws_subnet" "sn2"{
	cidr_block=var.v_sn2_cidr
	vpc_id=aws_vpc.vpc1.id
	availability_zone=var.v_sn2_az
	tags=merge(var.v_comm_tags,{"Name"="PRVSN2-MYVPC1"})
	
}
resource "aws_internet_gateway" "igw" {
	vpc_id=aws_vpc.vpc1.id
	tags=merge(var.v_comm_tags,{"Name"="IGW-MYVPC1"})
	
}
resource "aws_route_table" "pubrt" {
  vpc_id=aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags=var.v_comm_tags
}  
resource "aws_route_table_association" "rt1ass" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_eip" "nateip"{
}
resource "aws_nat_gateway" "nat"{
	subnet_id     =aws_subnet.sn1.id
	allocation_id =aws_eip.nateip.allocation_id
}
resource "aws_route_table" "rt2" {
  vpc_id=aws_vpc.vpc1.id
  tags=var.v_comm_tags
}
resource "aws_route" "natrt"{
	route_table_id =aws_route_table.rt2.id
	destination_cidr_block="0.0.0.0/0"
	nat_gateway_id=aws_nat_gateway.nat.id
} 
resource "aws_route_table_association" "rt2ass" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.rt2.id
}
 code is devoloped by ishaan
