# Repository Review Notes

The repository begins with the learner-supplied course files. The following maintenance changes make the collection easier to understand, validate, and reuse. They are not claimed as additional learner-performed AWS deployments.

| Area | Adjustment | Reason |
| --- | --- | --- |
| Exercise boundaries | Put each root in a separate numbered folder and normalize upload-suffix filenames | Prevent unrelated Terraform configurations from being combined |
| First S3 project | Keep one copy of the repeated random/S3/output definitions; separate providers, resources, and outputs | Duplicate addresses in one root would conflict |
| HCL overview | Retain the illustrative source as `s3.tf.example` | The external bucket and local child module were placeholders and were not supplied |
| CLI baseline | Declare Terraform 1.17.x across runnable roots | Match the learner's installed release and the automation baseline |
| Provider requirements | Preserve the two supplied AWS constraint lines: 6.70.x in foundational roots, 6.4.x in later labs | Avoid an unreviewed provider-major or minor upgrade across exercises |
| Backend | Use an empty S3 backend block and separate local-file templates with a generic bucket placeholder | Support partial configuration without publishing a learner-specific state destination |
| Backend locking | Add native S3 locking and encryption options to the templates | Make the documented storage intent explicit; runtime permissions and locking remain separately verifiable |
| EC2 AMI | Replace the fixed AMI literal with a required, format-checked input | Region, OS, architecture, ownership, and availability need verification before deployment |
| EC2 bootstrap | Add dependencies on the route association and outbound rule | The package installation needs working network egress |
| EC2 baseline | Encrypt the root volume, require IMDSv2, and fail the bootstrap on command errors | Improve the reusable lab baseline without changing its public-HTTP purpose |
| EC2 comments | Correct HTTP/HTTPS port wording; describe NGINX installation through user data | The code permits 80/443 but does not configure TLS; the uploaded checklist's AMI wording is historical |
| S3 website policy | Depend explicitly on the public-access configuration | Avoid relying on parallel operations to finish in a favorable order |
| S3 website access | Keep the two public-ACL protections enabled while allowing the intended public read policy | The example uses a bucket policy, not public ACLs |
| HTML assets | Convert hash-prefixed lines into HTML comments and add basic document metadata | A hash-prefixed line is not an HTML comment |
| Asset paths | Anchor HTML sources to `path.module`; expose an HTTP URL output | Keep the asset lookup and verification commands explicit |
| Automation | Add pinned GitHub Actions and configuration-only checks | Validate the repository without AWS deployment credentials |
| Data-source organization | Split the supplied provider and mixed practice file into providers, data sources, resources, and outputs in Exercise 07 | Keep the existing Terraform addresses while making each responsibility easy to review |
| Data-source AMI filter | Retain the supplied Ubuntu 22.04 name pattern and trusted owner; add an explicit x86_64 filter | Make architecture compatibility visible without changing the selected OS family |
| Data-source bucket name | Replace the globally fixed bucket name with a provider-generated name using `bucket_prefix` | Avoid requiring a globally unique literal in a reusable practice exercise |
| Generated policy scope | Replace the all-buckets object ARN with a reference to this exercise's bucket objects | Keep the example document scoped; the JSON remains unattached and does not grant access |
| Data-source EC2 baseline | Add root-volume encryption, required IMDSv2, and identifying tags | Match the reusable baseline used in the earlier EC2 lab; no new AWS runtime result is claimed |
| Data-source comments | Correct the claim that the bucket is read from AWS and clarify the independent VPC lookup | The bucket is a managed resource, and reading a VPC does not place the EC2 instance in it |
| Input-variable validation | Correct `contains` to receive the allowed list and candidate as separate arguments; use `t2.micro` and `t3.micro` literals | The uploaded snapshot used comma typos and an invalid list/variable expression; learner-reported successful tests remain a separate record |
| Input-variable provider lock | Keep the supplied AWS `~> 6.0` constraint and select the existing 6.4.0 practice baseline | Make initialization repeatable without changing the learner’s provider-major requirement |
| Input-variable tests | Add four mocked plan runs for defaults, supported overrides, unsupported values, and the comma typo | Verify the corrected guardrail without AWS credentials, API calls, or deployment |

## Material boundaries

- The HCL reference remains non-runnable until its dependencies are supplied.
- The backend templates require a pre-existing private state bucket and appropriate permissions.
- Exercise 05's EC2 AMI input is format-checked. Exercise 07 performs an AMI lookup only during an AWS-backed plan/apply; neither image availability nor the tagged VPC is verified against AWS by CI.
- Exercise 07 generates policy JSON but does not attach it to the S3 bucket. Its EC2 example retains default-VPC placement and requires a separate existing VPC tagged `Env=Prod` for the lookup.
- The public S3 website and NGINX lab do not demonstrate HTTPS.
- A configuration-only check does not establish resource cleanup or final charges.

[Verification ledger](verification.md) · [Source map](source-map.md)
