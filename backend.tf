terraform {
  backend "s3" {
    bucket         = "jenkastore"
    key            = "folder/statefile.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "Jenkaftable"
    encrypt        = true
  }
}
