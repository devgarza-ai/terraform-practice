# Learning Map

| Concept | Where it appears | Explanation to practice |
| --- | --- | --- |
| Declarative configuration | Every runnable exercise | Describe the desired resources and review the proposed changes |
| Provider requirements | Each root's Terraform block | Separate CLI requirements from provider constraints and selected lock-file versions |
| Implicit dependencies | VPC IDs, subnet IDs, gateway IDs, random suffixes | Explain how references establish ordering |
| Hidden dependencies | EC2 bootstrap and the public S3 policy | Explain why a behavior can require `depends_on` without a value reference |
| State | Every managed resource | Connect the resource address to the real object and preserve state ownership |
| Backend configuration | Exercise 04 | Explain the state location, environment keys, locking, and access controls |
| Shared expressions | Exercise 05 | Merge common tags with a resource-specific Name |
| Bootstrapping | Exercise 05 | Separate successful EC2 creation from a working NGINX application |
| Object change detection | Exercise 06 | Explain source files, object keys, MIME type, and a content checksum |
| Dynamic AMI selection | Exercise 07 | Explain regional IDs, trusted publishers, filters, and the newest matching image |
| Existing-resource lookups | Exercise 07 | Distinguish reading a tagged VPC from creating, importing, or selecting it for EC2 placement |
| AWS execution context | Exercise 07 | Inspect the caller, Region, and available AZs without hardcoding their returned values |
| Policy document generation | Exercise 07 | Separate generating JSON from attaching a policy and granting permissions |
| Lifecycle and drift | Course role-play discussion | Explain configuration ownership and selective `ignore_changes`; no separate drift lab is claimed here |

## Explain the work clearly

For an exercise walkthrough, connect the problem, the design choice, the observed result, and a limitation. Distinguish an operation completed in AWS from a file that only passed local validation.

The public-web-server and public-S3-site examples are bounded course exercises. Future infrastructure work can add production requirements after those requirements have been defined and verified.
