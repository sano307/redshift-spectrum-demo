# redshift-spectrum-demo

How to get the `parquet` data in S3 via Redshift Spectrum based on the Glue Table.

## Requirements

- Terraform 0.14.9
- Python 3.8.7
  - pipenv

## Environment

- macOS (Catalina)

## Usage

First of all, change the S3 bucket name what to store the `parquet` data.

```diff
// terraform.tfvars
- s3_bucket_parquet = "redshift-spectrum-demo"
+ s3_bucket_parquet = "YOUR_BUCKET_NAME"
```

Check the necessary infra resources and deploy to AWS cloud.

```sh
$ terraform init
$ terraform plan
$ terraform apply
```

Create the parquet data for testing, and upload this to S3 bucket.

```sh
$ cd utils
$ pipenv --python 3.8.7
$ pipenv install --dev
$ pipenv run python generate_parquet.py
$ aws s3 cp ../data/sample.parq s3://YOUR_BUCKET_NAME/parquet/
```

Check the endpoint and port of Redshift Cluster, and try to access Redshift Cluster using `psql` command.

```sh
$ aws redshift describe-clusters --cluster-identifier demo-redshift | jq '.Clusters[].Endpoint'
{
  "Address": "demo-redshift.xxxxxxxxxxxx.ap-northeast-1.redshift.amazonaws.com",
  "Port": 5439
}
$ psql -h demo-redshift.xxxxxxxxxxxx.ap-northeast-1.redshift.amazonaws.com -p 5439 -U admin -d demo
Password for user admin:
psql (13.2, server 8.0.2)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

demo=#
demo=#\q
```

Let's run the Glue Crawler for create a Glue Table in the Glue Catalog based on parquet data what uploaded to the S3 bucket.

```sh
$ aws glue start-crawler --name demo-crawler
$ aws glue get-table --database-name demo-database --name demo_parquet
```

And then, create an external schema for the Redshift Spectrum, because of connect to the Redshift cluster with the Glue Table. Don't forget to replace `YOUR_ACCOUNT_ID` with your account ID in `create-external-schema.sql`.

```sh
$ psql -h demo-redshift.xxxxxxxxxxxx.ap-northeast-1.redshift.amazonaws.com -p 5439 -U admin -d demo < sql/create-external-schema.sql
Password for user admin:
CREATE SCHEMA
```

Finally, let's query the `parquet` data in S3 via Redshift Spectrum.

```sh
$ psql -h demo-redshift.xxxxxxxxxxxx.ap-northeast-1.redshift.amazonaws.com -p 5439 -U admin -d demo < sql/get-parquet.sql > result
$ cat result
 year |  make  |  model
------+--------+---------
 2014 | toyota | corolla
 2017 | nissan | sentra
 2018 | honda  | civic
 2020 | hyndai | nissan
(4 rows)
```

You have to delete AWS resources if the verification was completed.

```sh
$ terraform destroy
```

## Author

Inseo Kim

## License

MIT
