## AWS S3 Application Asset Bucket

Amazon S3 (Simple Storage Service) is a scalable object storage service that allows you to store and retrieve any amount of data from anywhere on the web. With this service, you can manage application assets, such as files, static websites, backups, and more, with high durability, availability, and performance.

### Design Decisions

1. **KMS Integration**: Implemented server-side encryption using AWS KMS to ensure data at rest is always encrypted.
2. **IAM Policies**: Separate IAM policies for read and write access controls to ensure fine-grained access management.
3. **Access Logging**: Configurable access logging to monitor and review access to the S3 bucket.
4. **Public Access Block**: Enabled block public access settings to ensure the bucket is protected from unintended public access.
5. **Lifecycle Policies**: Lifecycle policies are in place to transition objects to intelligent tiering, optimizing storage costs.

### Runbook

#### Issue: Unable to Access S3 Bucket

If you are unable to access the S3 bucket, verify the following:

Check the bucket policy and ensure your IAM user or role has the necessary permissions.

```sh
aws s3api get-bucket-policy --bucket <bucket_name>
```

Verify the policy allows the required `s3:*` actions.

#### Issue: KMS Decryption Errors

If objects are not accessible due to KMS decryption errors, verify the IAM role has access to decrypt using the KMS key:

```sh
aws kms list-grants --key-id <kms_key_id>
```

Check if the required IAM role exists in the grant list.

#### Issue: Forbidden Error When Writing to Bucket

Ensure that the IAM policy associated with your role/user includes `s3:PutObject` and `s3:PutObjectAcl` actions:

```sh
aws iam get-policy --policy-arn arn:aws:iam::<account_id>:policy/<policy_name>
```

Validate if `PutObject`, `DeleteObject`, and other write operations are allowed.

#### Issue: Bucket Versioning Not Working

If S3 lifecycle rules or versioning do not appear to be functioning correctly, check the status of bucket versioning:

```sh
aws s3api get-bucket-versioning --bucket <bucket_name>
```

Ensure the response contains `"Status": "Enabled"`.

#### Issue: Monitoring Access Logs

To investigate access logs issues, ensure the bucket has logging enabled and points to the correct target bucket:

```sh
aws s3api get-bucket-logging --bucket <bucket_name>
```

Confirm `LoggingEnabled` is set with the appropriate target bucket and prefix. 

#### Issue: Lifecycle Rules Not Applied

If lifecycle rules are not being applied as expected, check the lifecycle configuration of the bucket:

```sh
aws s3api get-bucket-lifecycle-configuration --bucket <bucket_name>
```

Review the rules and ensure they are correctly configured and enabled.



