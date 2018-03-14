variable "bucket_account_id" {}

variable "bucket_actions" {
  description = "list of s3 actions allowed on bucket level, like List"
  type = "list"
  default = [
    "s3:ListBucket"
  ]
}

variable "bucket_name" {
  type = "string"
  description = "Name of the bucket"
}

variable "bucket_object_actions" {
  description = "list of s3 actions allowed on individual bucket objects"
  type = "list"
  default = [
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject"
  ]
}

variable "bucket_role_name" {}

variable "bucket_versioning" {
  description = "Bool value, whether the versioning for the bucket should be turned on"
  default = false
}
