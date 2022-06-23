provider "aws" {
  region  = var.aws_region
  profile = "default"
  default_tags {
     tags = {
       Environment = "Test"
       Owner       = "TFProviders"
       Project     = "Test"
     }
   }
}
