resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = "${var.bucket_versioning}"
  }

  lifecycle {
    # Can not be a variable at the moment
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "bucket-access-document" {
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

resource "aws_s3_bucket_policy" "bucket-access-policy" {
  bucket = "${aws_s3_bucket.bucket.bucket}"
  policy = "${data.aws_iam_policy_document.bucket-access-document.json}"
}
