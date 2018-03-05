resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = "${var.bucket_versioning}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "remote-backend-access" {
  statement {
    actions = [
      "${var.bucket_actions}"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}"
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
      "${aws_s3_bucket.terraform_state.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = "${aws_s3_bucket.terraform_state.bucket}"
  policy = "${data.aws_iam_policy_document.remote-backend-access.json}"
}