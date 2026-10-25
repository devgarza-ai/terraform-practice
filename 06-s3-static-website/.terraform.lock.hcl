# Provider selections and checksums verified against official HashiCorp archives.
# Update deliberately with terraform init -upgrade and review the resulting diff.

provider "registry.terraform.io/hashicorp/aws" {
  version     = "6.4.0"
  constraints = "~> 6.4.0"
  hashes = [
    "h1:hUzF9bzWMJKPJ3Q0b13sQAOTU5vHOc9m/S5HFPJl5Sk=",
    "zh:05946a97a2d98d3a77f2dfb1133b39d61b1166f717f051a8aa44eca22a7446b0",
    "zh:07278697234332b254e990fff84fa5608aabdb256a0dbed05dfe336905d385a1",
    "zh:1b1ad46267c84fa474618048a9ad94a634cf5d0e5ec3c8e56a854638129ae4da",
    "zh:1ff04914571b1dfa485358badbc81306e34d8ebec4aa1f96b8c1c3d2eb0e4d4a",
    "zh:43d7fb899186ca1b355af908d0904ea94a1e06de220de0b9752f06465386f66f",
    "zh:49ce34c359d5b05ba684482dace5e9c418f3beabcc2b0d129b21687cb7673cab",
    "zh:4bbad3a23dd704b1548da40e9c81befb617a0c02e5a9776ef0eff5ef920881c5",
    "zh:680aa4bd542c7a847f7df91cd1fa33fe8d19914aa80a2570ea6c82ab2d1f5740",
    "zh:792a74fe4d6b501571c582c25067f7f4dbdce2305d559d09981e7f99025c98ef",
    "zh:7c06b331b6a6f160d2d64245b9aee32922a9cb9947b7a9ad8c0ec93a702ecb1b",
    "zh:9f40add95d4f3e1c62df46bf37e13c30023d97eda47d4940904792f3b1a1827e",
    "zh:b763c7c1bf5d8077d6499fd270cad249a712dd9522c6a6e4de49b278280806c5",
    "zh:db69df59bef6f9d8bcb164414b4efa52c0c531c346d6b8b232917afa9b1c4a96",
    "zh:dd9f98f64530386b8faaf9c55ec4b08e58725788c38683272a34684d82f866f7",
  ]
}

provider "registry.terraform.io/hashicorp/random" {
  version     = "3.9.1"
  constraints = "~> 3.0"
  hashes = [
    "h1:g40qr7yDmIpaur4SsK5BcOda3HSo1RJ6zHVMqN4EJ+0=",
    "zh:05f4734c1f0be840b711b3eff259ebc5fca436784c728955b1678078466f48d7",
    "zh:0b91bf19371d012434eba1deeb6aab77158def9b39601dcbd94450b3974a2a26",
    "zh:0ee6eacd47ec00183d55d726a4b6c4ce951a199f944bf22f1aa58392ebdfa7a2",
    "zh:19388a4074b76a89a43a6c8328d7ae8ee2e7de3d346af51e80d3e6d3d12925f1",
    "zh:23e74d48c5e2ac2e823fd527f49fee9db37d32a1990c9e3bf126ead697b843eb",
    "zh:3cabf7fbd096c520064aae3aba61aba670af83ab91291a71fa1b1332929c2b7f",
    "zh:5c0a3b8af0be60be4eca12ddee385cfa8babc1ec8e98cdf9de2f2274c73eabfa",
    "zh:60b4f8a8ef18f52bf8e19215229dae408bee732825964092db7c989fd2de4097",
    "zh:7359015acfedcbd6366f2329c854cf8d3c8ca5cd0faa89d2d37db358d6eba6c5",
    "zh:7b38758402f0e13a1071162da28994023cd2ac676e54af350c9ffd8dfa73fa7b",
    "zh:7c7fbb8895eb75bb4de1f933e98553bd99c8d048c89a925ddba490aa5a67f7dc",
    "zh:8c2b8c6a7ccdec16b73e2fb9f3700ea097f58c592571e4c5de60c93d2301732c",
  ]
}
