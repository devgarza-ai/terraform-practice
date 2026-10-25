# 02 · HCL Building Blocks

A syntax reference from the first S3 learning materials. It is kept separate from the runnable first-S3 project because it illustrates a different concept.

## Reference

[s3.tf.example](s3.tf.example) demonstrates:

| Block | Purpose |
| --- | --- |
| `resource` | Declare a bucket managed by this configuration |
| `data` | Look up an externally managed bucket |
| `variable` | Define the bucket-name input |
| `output` | Expose the managed bucket ID |
| `locals` | Name an expression inside the module |
| `module` | Call a child module from a local path |

## Why the extension is `.example`

The referenced `./module_example` directory was not supplied, and the bucket named `not-managed-by-us` is a placeholder. The default managed-bucket name is also an illustration, not a uniqueness strategy. This reference is not advertised as a standalone deployment and is excluded from the five-root validation matrix.

To turn it into a future exercise, provide a real child module, deliberately choose an accessible external bucket, and supply an available managed-bucket name. That adaptation remains future work.

The [source map](../docs/source-map.md) records how this file relates to the other S3 uploads.
