resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id            = aws_vpc.main.id
    cidr_block       = var.public_subnets[count.index].cidr_block
    availability_zone = var.public_subnets[count.index].az

    tags = {
      name = "${var.project_name}/${var.public_subnets[count.index].name}"
    }

    depends_on = [
        aws_vpc_ipv4_cidr_block_association.main 
    ]
}
  
