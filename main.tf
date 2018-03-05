resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = "${var.bucket_versioning}"
  }

  lifecycle {
    prevent_destroy = "${var.bucket_prevent_destruction}"
  }
}

data "aws_iam_policy_document" "bucket-access" {
  statement {
    actions = [
      "${var.bucket_actions}"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}"
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${var.bucket_account_id}:role/${var.bucket_role_name}"
      ]
      type = "AWS"
    }
  }

  statement {
    actions = [
      "${var.bucket_object_actions}"
    ]

    principals {
      identifiers = [
        "arn:aws:iam::${var.bucket_account_id}:role/${var.bucket_role_name}"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.bucket}"
  policy = "${data.aws_iam_policy_document.bucket-access.json}"
}
