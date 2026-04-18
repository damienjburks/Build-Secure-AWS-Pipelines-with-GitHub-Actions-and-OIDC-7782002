# Build Secure AWS Pipelines with GitHub Actions and OIDC

This is the repository for the LinkedIn Learning course `Build Secure AWS Pipelines with GitHub Actions and OIDC`. The full course is available from [LinkedIn Learning][lil-course-url].

![lil-thumbnail-url]

## Course Description

Learn how to build secure CI/CD pipelines using GitHub Actions and AWS OIDC (OpenID Connect) — eliminating the need for long-lived AWS access keys. The course walks through deploying a web application (Vervium UI) to AWS using Terraform, progressing from IAM user credentials to a fully OIDC-based workflow.

## Prerequisites

- An [AWS account](https://aws.amazon.com/free/) with admin or sufficient IAM permissions
- A [GitHub](https://github.com) account
- Basic familiarity with Git, Terraform, and AWS concepts

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/build-secure-aws-pipelines-with-github-actions-and-oidc.git
cd build-secure-aws-pipelines-with-github-actions-and-oidc
```

### 2. Development Environment

This repo includes a [Dev Container](.devcontainer/devcontainer.json) configuration that automatically provisions Terraform, TFLint, and Terragrunt. You can use it with:

- **GitHub Codespaces** — click "Code > Codespaces > New codespace" on the repo page.
- **VS Code / Kiro** — install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension, then open the repo and select "Reopen in Container."

If you prefer a local setup, install the following manually:

| Tool | Version | Install Guide |
|------|---------|---------------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | >= 1.0 | `brew install terraform` or [download](https://developer.hashicorp.com/terraform/install) |
| [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | latest | `brew install awscli` or [download](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| [Git](https://git-scm.com/) | latest | `brew install git` or [download](https://git-scm.com/downloads) |

## Project Structure

```
.
├── .devcontainer/          # Dev Container configuration
├── .github/workflows/      # GitHub Actions CI/CD pipelines
│   ├── deploy.yml          # Deploy infrastructure via OIDC
│   └── destroy.yml         # Tear down infrastructure
├── chapters/               # Per-chapter reference files
│   ├── 01_01/deploy.yml    #   Ch1 — deploy with IAM access keys
│   ├── 03_03/deploy.yml    #   Ch3 — deploy with OIDC
│   └── 04_04/policy.json   #   Ch4 — least-privilege IAM policy
├── terraform/
│   ├── main.tf             # VPC, subnet, SG, S3, IAM, EC2 resources
│   ├── variables.tf        # Input variables (region, instance type)
│   ├── provider.tf         # AWS provider & Terraform version constraints
│   ├── backend.tf          # S3 remote state backend config
│   ├── data.tf             # Data sources (AMI, AZs, caller identity)
│   ├── locals.tf           # Computed locals (deployment method detection)
│   ├── outputs.tf          # Outputs (IP, URL, VPC ID, bucket name)
│   ├── user-data.sh        # EC2 bootstrap script (Apache + S3 sync)
│   └── vervium_ui/         # Static website files uploaded to S3
└── README.md
```

## Infrastructure Overview

The Terraform configuration provisions:

- A VPC with a public subnet, internet gateway, and route table
- A security group allowing inbound HTTP (port 80)
- A private S3 bucket containing the Vervium UI static assets
- An IAM role granting the EC2 instance read access to the S3 bucket
- An EC2 instance (Amazon Linux 2023) running Apache, which syncs the UI from S3 on boot

## Recommended Extensions

If you're using VS Code or Kiro, the following extensions are helpful:

- [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) — syntax highlighting, IntelliSense, and formatting for `.tf` files
- [GitHub Actions](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions) — syntax highlighting and validation for workflow YAML files
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) — general YAML language support
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) — open the repo inside the provided Dev Container

## Cleanup

To destroy all AWS resources created by this project:

```bash
cd terraform
terraform destroy
```

Or trigger the **Destroy Infrastructure** workflow from the GitHub Actions tab.

## Instructor

Damien Burks
Sr. Cloud Security Engineer & Founder of The DevSec Blueprint

Check out my other courses on [LinkedIn Learning](https://www.linkedin.com/learning/instructors/damien-burks).

[0]: # "Replace these placeholder URLs with actual course URLs"
[lil-course-url]: https://www.linkedin.com/learning/
[lil-thumbnail-url]: https://media.licdn.com/dms/image/v2/D4E0DAQG0eDHsyOSqTA/learning-public-crop_675_1200/B4EZVdqqdwHUAY-/0/1741033220778?e=2147483647&v=beta&t=FxUDo6FA8W8CiFROwqfZKL_mzQhYx9loYLfjN-LNjgA
