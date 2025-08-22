terraform {
  backend "s3" {
    bucket = "cloudnative-observability-tf-global-318839415844-ap-northeast-1"
    key = "dev/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "cloudnative-observability-tf-locks"
    encrypt = true
  }
}
