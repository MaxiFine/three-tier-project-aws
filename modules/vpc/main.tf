resource "aws_vpc" "vpc_01" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main_vpc"
  }
}


###########
# IGW #####
##########

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name = "vpc-igw"
  }
}



##################
## 6 SUBNETS CONFIGS
# Pub Sub 1
resource "aws_subnet" "public-web-subnet-1" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1 | WEB TIER"
  }

}


resource "aws_subnet" "public-web-subnet-2" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2 | WEB TIER"
  }

}


resource "aws_subnet" "private-app-subnet-1" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 1 | APP TIER"
  }

}


resource "aws_subnet" "private-app-subnet-2" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet 2 | APP TIER"
  }

}

resource "aws_subnet" "private-db-subnet-1" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.db_subnet_1_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private DB subnet 1 | DB TIER"
  }
}


resource "aws_subnet" "private-db-subnet-2" {
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.db_subnet_2_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private DB subnet 2 | DB TIER"
  }
}

#####################################
### 4 ROUTE TABLES
#####################
#### ROUTE TABLE ####
#####################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_internet_gateway.igw.id
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "Public Route Table"
  }
}


###################
### ROUTE ASSOC PUBLIC
resource "aws_route_table_association" "public-subnet-1-rt" {
  subnet_id      = aws_subnet.public-web-subnet-1.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public-subnet-2-rt" {
  subnet_id      = aws_subnet.public-web-subnet-2.id
  route_table_id = aws_route_table.public_route_table.id

}

#############################
## PRIVATE SUBNETS
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id # Corrected attribute name
  }


  tags = {
    Name = "Private Route Table"
  }
}



#########################
### ROUTE ASSOCIATIONS
resource "aws_route_table_association" "nat_route_1" {
  subnet_id      = aws_subnet.private-app-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}


resource "aws_route_table_association" "nat_route_2" {
  subnet_id      = aws_subnet.private-app-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}


##################################
##### DATABASE ROUTE ASSOC
resource "aws_route_table_association" "nat_route_db_1" {
  subnet_id      = aws_subnet.private-db-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}


resource "aws_route_table_association" "nat_route_db_2" {
  subnet_id      = aws_subnet.private-db-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}



#################################
## NAT GATEWAY CONFIGS
##################
## NAT GATEWAY
resource "aws_eip" "eip_nat" {
  # vpc = true
  domain = "vpc"

  tags = {
    Name = "nat-eip1"
  }

}


resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public-web-subnet-2.id

  tags = {
    Name = "Nat 1 with eip"
  }
}

