# Working with the Exercises

## Select one root

Each runnable numbered folder has its own configuration and state scope. Start in the selected folder. Running from the repository root will not collect the nested exercises into one deployment.

If resources already exist from an earlier working directory, keep using the state that owns them or deliberately plan state adoption. A new clone is not automatically connected to infrastructure created from another state.

## Authenticate locally

Use a configured AWS profile or temporary environment credentials on your own machine. AWS CLI and Terraform do not automatically load a `.env` file. Saving and explicitly loading environment values are separate from ignoring the file in Git.

Confirm the intended identity privately:

```bash
aws sts get-caller-identity
```

Credentials, state, plans, local backend files, and private keys stay outside tracked files. Provider lock files are committed.

## Check without a deployment

```bash
terraform init -backend=false -input=false
terraform fmt -check
terraform validate
```

Initialization installs the provider dependencies. Backend-free initialization does not contact the configured state bucket. Validation checks syntax and internal consistency; it does not verify AWS permissions, AMI availability, application health, or costs.

## Plan and apply deliberately

For a local-state exercise:

```bash
terraform init -input=false
terraform plan -out=tfplan
terraform show tfplan
terraform apply tfplan
```

Review creates, updates, replacements, and deletions in the saved plan. Treat plan files as sensitive. The backend exercise has its own environment-selection commands in [04 · S3 remote state](../04-s3-backend/README.md).

An apply can partially succeed. Read the error, inspect the managed state and real resources, correct the cause, and review the next plan before retrying.

## Verify behavior

Capture the output that proves the exercise's intended behavior: route associations for networking, object/bucket identity for S3, HTTP responses for a website, and a controlled lock check for remote state. Keep evidence separate from a course completion checkbox.

Use sanitized excerpts for public documentation. Include the result and its limits rather than turning a short lab into a production availability claim.

## Destroy with the owning state

```bash
terraform destroy
terraform state list
```

Use the same root, backend, environment selection, and identity that own the resources. Check that the actual exercise resources were removed; a screenshot of a completed lesson is not teardown evidence. State backups, separately managed backend storage, and other infrastructure can have their own lifecycles.

EC2, attached storage, public IPv4 usage, S3 storage, and requests can incur charges. Verify current AWS prices and account billing separately; no exercise is advertised as universally free.
