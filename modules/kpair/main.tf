resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_key" {
  key_name   = "TF_Key"
  public_key = tls_private_key.rsa.public_key_openssh
}


resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}