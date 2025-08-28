resource "aws_eip" "eip" {
    count = length(var.public_subnets)

    domain = "vpc"
    
    tags = {
      Name = "${var.project_name}/${var.public_subnets[count.index].name}"
    }
}

resource "aws_nat_gateway" "main" {
    count = length(var.public_subnets)
    allocation_id = aws_eip.eip[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = {
      Name = "${var.project_name}/${var.public_subnets[count.index].name}"
    }
  
}