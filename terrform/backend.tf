#backend
terraform {
  backend "s3" {
    bucket="priyankas21389"
    key="terraform.tfstate"
    region="ap-south-1"
    dynamodb_table = "priyanka-table"    
  }
}