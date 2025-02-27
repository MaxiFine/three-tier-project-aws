#################
# PRIVIDERS FOR S3 BUCKETS
provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "destination"
  region = "eu-central-1"
}


#################
## RANDOM ID's FOR BUCKET NAMES

resource "random_id" "source_bucket_suffix" {
  byte_length = 4
}

resource "random_id" "destination_bucket_suffix" {
  byte_length = 4
}


################################
## S3 SOURCE AND DESTINATION BUCKET
resource "aws_s3_bucket" "source_bucket" {
  provider = aws
  bucket        = "terra-source-bucket-${random_id.source_bucket_suffix.hex}"
  # acl           = "private"
  force_destroy = true

  tags = {
    Name        = "SourceBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.bucket
  provider = aws

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.destination
  bucket        = "terra-destination-bucket-${random_id.destination_bucket_suffix.hex}"
  # acl           = "private"
  force_destroy = true

  tags = {
    Name        = "DestinationBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
  provider = aws.destination
  bucket = aws_s3_bucket.destination_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}



##########################
# IAM CONFIGS FOR REPLICATIONS
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name        = "s3-replication-policy"
  description = "Allows S3 to replicate objects"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.source_bucket.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.source_bucket.bucket}"
        ]
      },
      {
        Action   = "s3:PutObject",
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${aws_s3_bucket.destination_bucket.bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_role_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}


#####################
# BUCKET REPLICATION CONIGS
resource "aws_s3_bucket_replication_configuration" "replication_config" {
  bucket = aws_s3_bucket.source_bucket.bucket
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "ReplicationRule1"
    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = aws_s3_bucket.destination_bucket.id
      storage_class = "STANDARD"
    }
  }
}


# #########################
# ## TESTING REPLICATION OBJECTS



# ###################
# # S3 CONFIGS
# resource "aws_s3_bucket" "source_bucket" {
#   provider      = aws
#   bucket        = "source-bucket-${random_id.source_bucket_suffix.hex}"
#   force_destroy = true

#   tags = {
#     Name        = "SourceBucket"
#     Environment = "Production"
#   }
# }

# resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
#   provider = aws
#   bucket   = aws_s3_bucket.source_bucket.bucket

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket" "destination_bucket" {
#   provider      = aws.destination
#   bucket        = "destination-bucket-${random_id.destination_bucket_suffix.hex}"
#   force_destroy = true

#   tags = {
#     Name        = "DestinationBucket"
#     Environment = "Production"
#   }
# }

# resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
#   provider = aws.destination
#   bucket   = aws_s3_bucket.destination_bucket.bucket

#   versioning_configuration {
#     status = "Enabled"
#   }
# }
