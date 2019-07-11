variable "ccitoken" {}
variable "ghtoken" {}
variable "ghorg" {
  default = "mannytestorg"
}

provider "github" {
  version      = "~> 2.2"
  token        = var.ghtoken
  organization = var.ghorg
}
provider "aws" {
  version = ">= 2.11.0"
}

# Set-up s3 backend
terraform {
  backend "s3" {
    bucket         = "mannytestorg-tf-state"
    key            = "terraform/state/ghrepos"
    encrypt        = true
    dynamodb_table = "manny-terraform-state-lock-dynamo"
    region         = "us-east-2"
  }
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket = "mannytestorg-tf-state"
    key    = "terraform/state/ghrepos"
    region = "us-east-2"
  }
}

resource "github_repository" "ghconfig" {
  name        = "ghconfig"
  description = "GH config repo"
  auto_init   = true
  provisioner "local-exec" {
    command = "curl -s -u ${var.ccitoken}: -X POST https://circleci.com/api/v1.1/project/github/${var.ghorg}/${self.name}/follow"
  }
}

resource "github_branch_protection" ghconfig_master_branch {
  repository     = github_repository.ghconfig.name
  branch         = "master"
  enforce_admins = true
  required_status_checks {
    strict = true
    contexts = ["check"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews = true
  }
}


resource "github_repository" "test" {
  name        = "test"
  description = "Test repo"
  auto_init   = true
  provisioner "local-exec" {
    command = "curl -s -u ${var.ccitoken}: -X POST https://circleci.com/api/v1.1/project/github/${var.ghorg}/${self.name}/follow"
  }
}

resource "github_branch_protection" test_master_branch {
  repository     = github_repository.test.name
  branch         = "master"
  enforce_admins = true
  required_status_checks {
    strict = true
    contexts = ["check"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews = true
  }
}

resource "github_repository" "another_test" {
  name        = "another_test"
  description = "Another test repo"
  auto_init   = true
  provisioner "local-exec" {
    command = "curl -s -u ${var.ccitoken}: -X POST https://circleci.com/api/v1.1/project/github/${var.ghorg}/${self.name}/follow"
  }
}

resource "github_branch_protection" another_test_master_branch {
  repository     = github_repository.another_test.name
  branch         = "master"
  enforce_admins = true
  required_status_checks {
    strict = true
    contexts = ["check"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews = true
  }
}

#resource "github_membership" "desbonnm-test" {
#  username = "desbonnm-test"  # has to be username - email does not work.
#}
#resource "github_membership" "desbonnm-test2" {
#  username = "desbonnm-test2"
#}
  
