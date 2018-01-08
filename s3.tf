resource "aws_kms_key" "bucket_key" {
  description             = "This key is used to encrypt APPS buckets"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "log_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_log"]}"
  acl    = "${var.s3_bucket_acl["archive_log"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-log-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "log_archive_bucket_policy" {
  bucket = "${aws_s3_bucket.log_archive_bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.amazonaws.com"
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketAcl"
      ],
      "Resource": "${aws_s3_bucket.log_archive_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.amazonaws.com"
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.log_archive_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "data_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_data"]}"
  acl    = "${var.s3_bucket_acl["archive_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-data-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "data_archive_bucket_policy" {
  bucket = "${aws_s3_bucket.data_archive_bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "data_working_bucket" {
  bucket = "${var.s3_bucket_name["working_data"]}"
  acl    = "${var.s3_bucket_acl["working_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-data-working-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "data_working_bucket_policy" {
  bucket = "${aws_s3_bucket.data_working_bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.data_working_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.data_working_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "data_landing_bucket" {
  bucket = "${var.s3_bucket_name["landing_data"]}"
  acl    = "${var.s3_bucket_acl["landing_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-data-landing-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "data_landing_bucket_policy" {
  bucket = "${aws_s3_bucket.data_landing_bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "s3:ListBucket",
      "Resource": ["${aws_s3_bucket.data_landing_bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.data_landing_bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}