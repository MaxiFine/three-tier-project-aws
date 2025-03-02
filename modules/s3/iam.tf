# resource "aws_iam_role" "replication" {
#   name = "s3-bucket-replication-${random_pet.this.id}"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "s3.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "replication" {
#   name = "s3-bucket-replication-${random_pet.this.id}"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetReplicationConfiguration",
#         "s3:ListBucket"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${local.bucket_name}"
#       ]
#     },
#     {
#       "Action": [
#         "s3:GetObjectVersion",
#         "s3:GetObjectVersionAcl"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${local.bucket_name}/*"
#       ]
#     },
#     {
#       "Action": [
#         "s3:ReplicateObject",
#         "s3:ReplicateDelete"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:s3:::${local.destination_bucket_name}/*"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy_attachment" "replication" {
#   name       = "s3-bucket-replication-${random_pet.this.id}"
#   roles      = [aws_iam_role.replication.name]
#   policy_arn = aws_iam_policy.replication.arn
# }

resource "aws_iam_policy" "replication" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # S3 Permissions
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:GetObjectVersion",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      # KMS Permissions (Critical Fix)
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*"
        ],
        Effect   = "Allow",
        Resource = aws_kms_key.replica.arn
      }
    ]
  })
}



resource "aws_kms_key" "replica" {
  provider = aws.replica

  description             = "S3 Replica Bucket KMS Key"
  deletion_window_in_days = 7

  # Key policy allowing the replication role
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "s3-replication-key",
    Statement = [
      {
        Sid    = "EnableReplicationRole",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.replication.arn
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowRootAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
}

