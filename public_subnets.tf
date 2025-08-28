# Cria uma ou mais sub-redes públicas com base em var.public_subnets.
# - Usa `count` para instanciar várias subnets conforme a lista fornecida.
# - Atribui à VPC (`vpc_id`), define o bloco CIDR e a zona de disponibilidade por item.
# - Aplica tag `Name` no formato "<project_name>/<subnet_name>".
# - Depende da associação de faixa IPv4 da VPC para garantir que o CIDR esteja disponível antes da criação.
# Observação: para que a subnet seja realmente pública, é necessário associá-la a uma tabela de rotas com rota para um Internet Gateway (não mostrado aqui).
resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id            = aws_vpc.main.id
    cidr_block       = var.public_subnets[count.index].cidr_block
    availability_zone = var.public_subnets[count.index].az

    tags = {
      Name = "${var.project_name}/${var.public_subnets[count.index].name}"
    }

    depends_on = [
        aws_vpc_ipv4_cidr_block_association.main 
    ]
}

# Tabela de Rotas para Subnets Públicas
# Cria uma tabela de roteamento dentro da VPC especificada que será usada para subnets públicas
# Esta tabela de rotas será associada às subnets públicas para permitir acesso à internet
resource "aws_route_table" "public_internet_access" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}/PublicRouteTable"
    }    
  
}
# Define uma rota para o tráfego de Internet na tabela de rotas pública
# Configura o roteamento de todo o tráfego (0.0.0.0/0) para ser direcionado através
# do Internet Gateway, permitindo que recursos nas subnets públicas tenham acesso
# direto à Internet
resource "aws_route" "public" {
    route_table_id         = aws_route_table.public_internet_access.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
  
}

# Associa as subnets públicas à tabela de rotas pública
# - Usa count para criar múltiplas associações, uma para cada subnet pública
# - Conecta cada subnet pública criada anteriormente com a tabela de rotas que contém
#   a rota para o Internet Gateway, efetivamente tornando as subnets públicas

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public_internet_access.id
}