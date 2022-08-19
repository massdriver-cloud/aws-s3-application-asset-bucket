# aws-s3-application-asset-bucket

AWS S3 Bucket optimized for storing arbitrary application files like avatar images, CSV uploads, videos, and more.

## What Is A Bundle  

Bundles are the basic building blocks of infrastructure, applications, and architectures in Massdriver. They are composed of Terraform modules or Helm charts. Read more [here](https://docs.massdriver.cloud/concepts/bundles).

## Developing  

### How To Develop A Bundle

To learn how to develop a bundle for Massdriver, check out our [bundle docs](https://docs.massdriver.cloud/bundles/development).

### Contribution guidelines

So you're interested in contributing to Massdriver Bundles?  Please refer to Massdriver's overall
[contribution guidelines](https://docs.massdriver.cloud/bundles/contributing) to find out how you
can help with existing bundles or open source your own bundle.

# JSON Schema

## Properties

- **`bucket`** *(object)*: Cannot contain additional properties.
  - **`region`** *(string)*: AWS Region to provision in.

    Examples:
    ```json
    "us-west-2"
    ```

## Examples

  ```json
  {
      "__name": "Default",
      "bucket": {
          "region": "us-west-2"
      }
  }
  ```

