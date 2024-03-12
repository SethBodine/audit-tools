mod "local" {
  title = "powerpipe"
  require {
    mod "github.com/turbot/steampipe-mod-aws-insights" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-thrifty" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-azure-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-azure-thrifty" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-azure-insights" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-gcp-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-gcp-insights" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-gcp-thrifty" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-kubernetes-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-kubernetes-insights" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-net-insights" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-microsoft365-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-github-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-terraform-aws-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-terraform-azure-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-terraform-gcp-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-perimeter" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-top-10" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-well-architected" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-github-sherlock" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-digitalocean-insights.git" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-snowflake-compliance.git" {
      version = "*"
    }
  }
}
