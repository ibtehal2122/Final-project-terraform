# --- 1. VPC Creation ---
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # Required for EKS to resolve cluster endpoints
  enable_dns_hostnames = true
  enable_dns_support   = true

tags = merge(
    { Name = "eks-vpc" },
    var.tags
  )
}

# --- 2. Internet Gateway (IGW) ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}

# --- 3. Public Subnets ---
# Needs 'kubernetes.io/role/elb' tag for Public Load Balancers
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "public-1"
    "kubernetes.io/role/elb" = "1" # Crucial for EKS Load Balancer
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "public-2"
    "kubernetes.io/role/elb" = "1"
  }
}

# --- 4. Private Subnets ---
# Needs 'kubernetes.io/role/internal-elb' tag for Internal Load Balancers
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1
  availability_zone = "${var.region}a"

  tags = {
    Name                              = "private-1"
    "kubernetes.io/role/internal-elb" = "1" # Crucial for internal LB
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2
  availability_zone = "${var.region}b"

  tags = {
    Name                              = "private-2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# --- 5. NAT Gateway (Single NAT for Cost Savings) ---
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "eks-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  # Place NAT in the first Public Subnet
  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "eks-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# --- 6. Route Tables ---

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table (Single RT pointing to Single NAT)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
