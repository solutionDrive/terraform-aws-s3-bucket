resource "aws_s3_bucket" "terraform_state" {
  bucket = "sd-infrastructure-up-and-running-state-${var.account_id}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = "${aws_s3_bucket.terraform_state.bucket}"
  policy = "${data.aws_iam_policy_document.remote-backend-access.json}"
}