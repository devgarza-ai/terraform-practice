# Pestech Preview · Terraform on AWS

**Ivan Garza · [devgarza-ai](https://github.com/devgarza-ai) · Deployed November 6, 2026**

A temporary website preview for a family pest-control business, provisioned with Terraform and delivered through CloudFront to Nginx on EC2. The release archive lives in private S3; a Python helper deploys it through AWS Systems Manager Run Command and verifies the installation.

I manually typed the Terraform configuration in WSL during guided practice, reviewed the execution plans, applied the infrastructure, deployed the release, and checked the result on desktop and phone. Website assets, the Python deployment helper, and this portfolio documentation were prepared with AI assistance. This is a hands-on learning project with a working AWS deployment.

**Deployment status:** verified on AWS. **Source publication:** the uploaded bootstrap script and deployment helper are included; the exact Terraform files and provider lock file from the working WSL directory are awaiting upload. This folder is not yet a complete, independently runnable Terraform root. It does not substitute reconstructed configuration for the learner's typed files.

![Pestech AWS preview architecture](docs/Pestech_Preview_AWS_Architecture.svg)

[Save the architecture SVG](docs/Pestech_Preview_AWS_Architecture.svg) · [Architecture notes](docs/architecture.md) · [Deployment workflow](docs/operations.md) · [Verified results](docs/verification.md)

## What I accomplished

- Built the preview's AWS network with a VPC, public subnet, internet gateway, public route table, and security-group rules.
- Configured an EC2 `t3.micro` web server with an encrypted gp3 root volume, required IMDSv2, and Nginx bootstrapping.
- Attached an instance role for Systems Manager and scoped `s3:GetObject` access to the website release object.
- Uploaded the approved archive to private S3 with public access blocked and AES256 object encryption.
- Deployed through SSM without opening SSH ingress; checked the archive's SHA-256, Nginx configuration, health endpoint, pages, and assets.
- Added CloudFront with a default CloudFront certificate, HTTP-to-HTTPS redirect for viewers, and disabled caching during review.
- Verified the public HTTPS homepage, owner demo, share image, and deployed motion files.
- Confirmed the original PESTECH-only wordmark in an actual iPhone Messages link preview.
- Finished with a Terraform plan reporting no pending changes.

## Architecture at a glance

| Flow | Implementation |
| --- | --- |
| Visitor requests | Browser → HTTPS/443 → CloudFront → HTTP/80 → EC2/Nginx through public VPC routing |
| Infrastructure changes | WSL Terraform → reviewed plan → AWS resources |
| Release upload | Terraform → private S3 object at `releases/pestech-site.tar.gz` |
| Release installation | Python helper → SSM Run Command → SSM Agent on EC2 → approved bundle download from S3 |
| Authorization | Instance profile, SSM managed policy, and S3 read permission scoped to the release key |

CloudFront is a global edge service. EC2 and the release bucket are in `us-east-1`. The instance is in VPC `10.42.0.0/16`, public subnet `10.42.1.0/24`. S3 is an artifact store for this deployment; the website's CloudFront custom origin is EC2.

## Preview link and scope

[Temporary HTTPS preview](https://duf55cyi4jiw6.cloudfront.net/)

The address is a temporary deployment endpoint and may be retired after review. The website and owner workspace remain frontend demonstrations with browser-local records. Live authentication, a shared customer database, email delivery, and live AI are future implementation work. This preview does not claim high availability or production readiness.

The CloudFront-to-origin connection uses HTTP, and the public EC2 origin remains directly reachable on port 80. Viewer HTTPS and private artifact storage do not imply origin isolation or encryption on every hop. The diagram records that deployed boundary explicitly.

## Files

| Path | Purpose |
| --- | --- |
| `user-data.sh` | Learner-uploaded EC2 bootstrap and Nginx configuration |
| `deploy-site.py` | AI-assisted SSM deployment helper paired to the approved release checksum |
| `pestech-site.tar.gz.sha256` | SHA-256 of the verified release; the website archive is supplied separately |
| `docs/` | Architecture SVG, explanation, operations, and deployment evidence |

Keep state, saved plans, AWS credentials, local configuration, release archives, and deployment receipts outside Git. The repository's ignore rules protect the common generated filenames. Actual Terraform source will be checked before publication when the WSL source archive is supplied.

## Learning outcomes

This project connects resource references, dependency order, networking, IAM instance permissions, bootstrapping, artifact delivery, and post-deployment verification. The final clean plan checks Terraform-managed infrastructure; the separate HTTP and deployment checks establish that the application files are being served.
