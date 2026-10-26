# Source Map

The explicit upload batches supply nineteen source files. Filenames with numeric suffixes are normalized within the appropriate exercise folder. Their source hashes identify the supplied bytes before repository formatting and the documented edits.

| Uploaded file | Repository destination / treatment | Original SHA-256 |
| --- | --- | --- |
| `vpc.tf` | 01-vpc-foundations/vpc.tf | `9144d233e93d9124e4ae533dc00c2ebaa2c405762716970efe1f32f61e80e2f4` |
| `s3(3).tf` | 02-hcl-building-blocks/s3.tf.example | `aa5ed8c68d62c597a9055bc0ad16e4fc1e18b09882b648d73124b2a6aef39548` |
| `providers(1).tf` | 03-first-s3-project/providers.tf; duplicate resource/output blocks consolidated | `2fcc1c19745ccf874cd51735056dbb42f75fd6566946da87768d57604d1e3c72` |
| `s3(2).tf` | 03-first-s3-project/s3.tf and outputs.tf | `9f664f36f8abf494d5a58c8786eccf4696def4971ef4edf5181074a527ac4018` |
| `providers.tf` | 04-s3-backend/providers.tf | `6472bebd2de07f66b793591c6b6361f20bd8645e9175b1e867872971d377ae30` |
| `s3(1).tf` | 04-s3-backend/s3.tf and outputs.tf | `9f664f36f8abf494d5a58c8786eccf4696def4971ef4edf5181074a527ac4018` |
| `dev.s3.tfbackend` | 04-s3-backend/backend-config/dev.s3.tfbackend.example | `07efc43217d8e703b75a53cce5f572ad917c4572bf1f504085cf49b64fe46da5` |
| `prod.s3.tfbackend` | 04-s3-backend/backend-config/prod.s3.tfbackend.example | `c2c01043a0b0dae4c9361905963f0778ef3b0befda819b95034f274b296be917` |
| `provider(2).tf` | 05-ec2-nginx/providers.tf | `4a3aad66730e8e28906af7da4e952cc8304149a0539689287fa557c22446f96a` |
| `networking(1).tf` | 05-ec2-nginx/networking.tf | `e657882967ada2c830eb7892eefd048451b9682b59f8144c28a55b39a9a73807` |
| `compute(1).tf` | 05-ec2-nginx/compute.tf; AMI input and reusable-lab changes documented | `f9ebdeb310bd22171982b171028d7993b7019edbe254f915a7bb721b2adb7c7a` |
| `README(1).md` | 05-ec2-nginx/README.md and docs/verification.md; implementation checklist preserved as evidence context | `2f2ad2d3ffadef430a44ae0d8cf5827e349052b84e7ad8b6eec09adba7433a71` |
| `provider.tf` | 06-s3-static-website/providers.tf | `625a7024be25683528e59fd6205bc2b49f18264f086c81d7e1d0e29dc07408f4` |
| `s3.tf` | 06-s3-static-website/s3.tf | `8c941589d689f162515edd2141c38ec761cc0d0b28b162ce0d4fe98c2936ee23` |
| `outputs.tf` | 06-s3-static-website/outputs.tf | `590537540757308ab10b87b945468a0f97406de843088768c63d9d862d9e86db` |
| `index.html` | 06-s3-static-website/build/index.html | `72872c959dd623a7f0ef73877a73582f48a6c43126ee21b25d8567b9f76afce2` |
| `error.html` | 06-s3-static-website/build/error.html | `4c0cf3a8ca52de86672bb10c69f418836762503d211cbb49121ab63a8ae97095` |
| `provider(3).tf` | 07-data-sources/providers.tf | `6250a0d2059eab77eadc9c44e297026cf2be22748244860c77a142172c7ada3d` |
| `compute(2).tf` | 07-data-sources/data.tf, compute.tf, s3.tf, and outputs.tf; scoped policy and reusable-lab changes documented | `a27f83fd4e472d73eff51b488a4fc7d2211effed36bd7b0bd0c4b835079439e0` |

The HCL overview and first runnable S3 project remain separate: one demonstrates block syntax with unresolved placeholders, while the other creates a randomly named bucket. The provider snapshot that repeats the first-S3 resources was consolidated instead of publishing duplicate resource definitions.

The [review notes](review-notes.md) list the implementation changes. No credential, state, or plan file is included in this source map or repository.
